#!/usr/bin/env python3
"""
ghee-cli — Interactive TUI for fuzzy-searching shell commands.

Provides a Rich-powered interface to search, select, and copy shell shortcuts
from the ghee registry. Supports custom commands, usage tracking, and AI-assisted
command generation via Ollama.
"""

import os
import sys
import re
import subprocess
import json
import time
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Any

try:
    from rich.console import Console
    from rich.table import Table
    from rich.panel import Panel
    from rich.text import Text
    from rich import box
    RICH_AVAILABLE = True
except ImportError:
    RICH_AVAILABLE = False

# Fallback print functions if rich is not available
if not RICH_AVAILABLE:
    def print_err(msg: str) -> None: print(f"[ERR] {msg}", file=sys.stderr)
    def print_ok(msg: str) -> None: print(f"[ok] {msg}")
    def print_info(msg: str) -> None: print(f"[..] {msg}")
    def print_warn(msg: str) -> None: print(f"[WARNING] {msg}")
else:
    console = Console()
    def print_err(msg: str) -> None: console.print(f"[bold red][ERR][/bold red] {msg}", err=True)
    def print_ok(msg: str) -> None: console.print(f"[bold green][ok][/bold green] {msg}")
    def print_info(msg: str) -> None: console.print(f"[bold cyan][..][/bold cyan] {msg}")
    def print_warn(msg: str) -> None: console.print(f"[bold yellow][WARNING][/bold yellow] {msg}")

CUSTOM_FILE = Path.home() / ".ghee-custom"
STATS_FILE = Path.home() / ".ghee-stats.json"
CACHE_FILE = Path.home() / ".ghee-registry-cache.json"
CONFIG_FILE = Path.home() / ".ghee-config.json"


def load_stats() -> Dict[str, int]:
    """Load usage statistics from the stats file."""
    if STATS_FILE.exists():
        try:
            return json.loads(STATS_FILE.read_text())
        except (json.JSONDecodeError, IOError) as e:
            print_err(f"Corrupted stats file: {e}")
            return {}
    return {}


def record_usage(key: str) -> None:
    """Record usage of a command for ranking popular commands."""
    try:
        stats = load_stats()
        stats[key] = stats.get(key, 0) + 1
        STATS_FILE.write_text(json.dumps(stats, indent=2))
    except IOError as e:
        print_err(f"Failed to record usage: {e}")


def load_config() -> Dict[str, Any]:
    """Load user configuration from ~/.ghee-config.json."""
    if CONFIG_FILE.exists():
        try:
            return json.loads(CONFIG_FILE.read_text())
        except (json.JSONDecodeError, IOError) as e:
            print_err(f"Corrupted config file: {e}")
            return {}
    return {}


def validate_command_input(cmd: str) -> Tuple[bool, str]:
    """
    Validate a command for safety before adding to registry.
    
    Returns:
        Tuple of (is_valid, error_message)
    """
    if not cmd or not cmd.strip():
        return False, "Command cannot be empty"
    
    if len(cmd) > 500:
        return False, "Command too long (max 500 characters)"
    
    # Check for obviously dangerous patterns
    dangerous_patterns = [
        (r'rm\s+(-rf?|--force)\s+/', "Deleting root files is not allowed"),
        (r'mkfs', "Formatting disks is not allowed"),
        (r'dd\s+if=', "Using dd is not allowed"),
        (r'>/dev/sd', "Writing to block devices is not allowed"),
        (r'chmod\s+777\s+/', "World-writable permissions on root is not allowed"),
        (r'wget.*\|\s*(ba)?sh', "Piping wget to shell is not allowed"),
        (r'curl.*\|\s*(ba)?sh', "Piping curl to shell is not allowed"),
    ]
    
    cmd_lower = cmd.lower()
    for pattern, message in dangerous_patterns:
        if re.search(pattern, cmd_lower):
            return False, message
    
    return True, ""


def validate_alias_input(alias: str) -> Tuple[bool, str]:
    """Validate an alias for safety and correctness."""
    if not alias or not alias.strip():
        return False, "Alias cannot be empty"
    
    if len(alias) > 100:
        return False, "Alias too long (max 100 characters)"
    
    # Allow alphanumeric, spaces, hyphens, underscores, dots
    if not re.match(r'^[a-zA-Z0-9\s\-_.]+$', alias):
        return False, "Alias contains invalid characters (only alphanumeric, spaces, hyphens, underscores, dots allowed)"
    
    return True, ""


def validate_desc_input(desc: str) -> Tuple[bool, str]:
    """Validate a description string."""
    if not desc or not desc.strip():
        return False, "Description cannot be empty"
    
    if len(desc) > 200:
        return False, "Description too long (max 200 characters)"
    
    return True, ""


def load_registry() -> Dict[str, Dict[str, str]]:
    """
    Load built-in commands from ghee modules and custom commands.

    Uses caching to speed up subsequent loads. Cache is invalidated if module
    files have been modified since the last cache was written.

    Returns:
        dict: A dictionary where keys are alias names, and values are dicts
              containing 'cmd' (the bash command) and 'desc' (a brief description).
    """
    config = load_config()
    use_cache = config.get("enable_cache", True)
    cache_ttl = config.get("cache_ttl_seconds", 300)  # 5 minutes default

    if use_cache:
        cached = load_registry_cache()
        if cached and not cache_needs_rebuild(cache_ttl):
            return cached

    registry = {}

    # Try to find modules directory relative to this file
    script_dir = Path(__file__).parent.parent.parent  # src/ghee_cli -> ghee root
    modules_dir = script_dir / "modules"

    if not modules_dir.exists():
        # Fallback: try current working directory
        modules_dir = Path.cwd() / "modules"

    if modules_dir.exists():
        for mod_file in modules_dir.glob("*.sh"):
            try:
                content = mod_file.read_text()
                matches = re.finditer(r'_GG_REGISTRY\["(.*?)"\]="(.*?)\|\|\|(.*?)"', content)
                for m in matches:
                    key = m.group(1).strip()
                    cmd = m.group(2).strip()
                    desc = m.group(3).strip()
                    registry[key] = {"cmd": cmd, "desc": desc}
            except IOError as e:
                print_err(f"Failed to read module {mod_file}: {e}")

    # Load custom
    if CUSTOM_FILE.exists():
        try:
            for line in CUSTOM_FILE.read_text().splitlines():
                if "|||" in line:
                    parts = line.split("|||")
                    if len(parts) >= 3:
                        registry[parts[0].strip()] = {
                            "cmd": parts[1].strip(),
                            "desc": parts[2].strip()
                        }
        except IOError as e:
            print_err(f"Failed to read custom file: {e}")

    # Save to cache
    if use_cache:
        save_registry_cache(registry)

    return registry


def load_registry_cache() -> Optional[Dict[str, Dict[str, str]]]:
    """Load registry from cache if available."""
    if CACHE_FILE.exists():
        try:
            cache_data = json.loads(CACHE_FILE.read_text())
            return cache_data.get("registry")
        except (json.JSONDecodeError, IOError):
            pass
    return None


def cache_needs_rebuild(ttl_seconds: int = 300) -> bool:
    """Check if cache needs to be rebuilt based on TTL and file modifications."""
    if not CACHE_FILE.exists():
        return True

    try:
        cache_data = json.loads(CACHE_FILE.read_text())
        cache_time = cache_data.get("timestamp", 0)
        current_time = time.time()

        if current_time - cache_time > ttl_seconds:
            return True

        # Find modules directory
        script_dir = Path(__file__).parent.parent.parent
        modules_dir = script_dir / "modules"
        if not modules_dir.exists():
            modules_dir = Path.cwd() / "modules"

        if modules_dir.exists():
            for mod_file in modules_dir.glob("*.sh"):
                if mod_file.stat().st_mtime > cache_time:
                    return True

        if CUSTOM_FILE.exists() and CUSTOM_FILE.stat().st_mtime > cache_time:
            return True

        return False
    except (json.JSONDecodeError, IOError, KeyError):
        return True


def save_registry_cache(registry: Dict[str, Dict[str, str]]) -> None:
    """Save registry to cache file."""
    try:
        cache_data = {
            "registry": registry,
            "timestamp": time.time(),
            "version": "1.0"
        }
        CACHE_FILE.write_text(json.dumps(cache_data, indent=2))
    except IOError as e:
        print_err(f"Failed to save cache: {e}")


def add_custom(alias: str, desc: str) -> None:
    """
    Add a custom shortcut to the registry.

    Validates inputs for safety and correctness before adding to the custom file.
    """
    alias_valid, alias_err = validate_alias_input(alias)
    if not alias_valid:
        print_err(f"Invalid alias: {alias_err}")
        sys.exit(1)

    desc_valid, desc_err = validate_desc_input(desc)
    if not desc_valid:
        print_err(f"Invalid description: {desc_err}")
        sys.exit(1)

    cmd_valid, cmd_err = validate_command_input(alias)
    if not cmd_valid:
        print_err(f"Invalid command: {cmd_err}")
        sys.exit(1)

    cmd = alias
    try:
        with open(CUSTOM_FILE, "a") as f:
            f.write(f"{alias}|||{cmd}|||{desc}\n")
        print_ok(f"Added: [bold]{alias}[/bold] -- {desc}" if RICH_AVAILABLE else f"Added: {alias} -- {desc}")
        print_info(f"Saved to {CUSTOM_FILE}")
        
        if CACHE_FILE.exists():
            try:
                CACHE_FILE.unlink()
            except IOError:
                pass
    except IOError as e:
        print_err(f"Failed to write to custom file: {e}")
        sys.exit(1)


def score_match(query: str, key: str, cmd: str, desc: str) -> int:
    """
    Score the match of a query against a command alias, actual command, and description.

    Implements an improved word-overlap fuzzy scoring algorithm.
    """
    query = query.lower().strip()
    key = key.lower()
    cmd = cmd.lower()
    desc = desc.lower()

    if not query:
        return 0

    score = 0

    if cmd == query:
        score += 1000
    if key == query:
        score += 900

    if query in cmd:
        score += 500
    if cmd in query and cmd:
        score += 400
    if query in key:
        score += 300
    if query in desc:
        score += 200

    query_words = query.split()
    cmd_words = cmd.split()
    desc_words = desc.split()
    key_words = re.split(r'[\s\-_]+', key)

    for qword in query_words:
        if len(qword) < 2:
            continue

        for cword in cmd_words:
            if qword in cword or cword in qword:
                score += 75
                break

        for dword in desc_words:
            if qword in dword or dword in qword:
                score += 40
                break

        for kword in key_words:
            if qword in kword or kword in qword:
                score += 50
                break

    for i in range(len(query) - 2):
        substr = query[i:i+3]
        if substr in cmd:
            score += 20
        if substr in key:
            score += 15

    return score


def get_ollama_model():
    """Check if Ollama is running and return a preferred model. Returns None if unavailable."""
    import urllib.request
    try:
        req = urllib.request.Request("http://localhost:11434/api/tags")
        with urllib.request.urlopen(req, timeout=2) as response:
            data = json.loads(response.read().decode('utf-8'))
            models = [m['name'] for m in data.get('models', [])]
            for pref in ['llama3.2', 'llama3', 'mistral', 'codellama']:
                for m in models:
                    if m.startswith(pref):
                        return m
            if models:
                return models[0]
    except Exception:
        pass
    return None


def ask_ollama(query, model):
    """Ask Ollama to generate a shell command. Returns None on failure."""
    import urllib.request
    try:
        url = "http://localhost:11434/api/generate"
        prompt = f"Convert this natural language idea into a single, valid bash/shell command for macOS/Linux. Output ONLY the command, no markdown formatting, no backticks, no explanations. Idea: {query}"
        data = {
            "model": model,
            "prompt": prompt,
            "stream": False
        }
        req = urllib.request.Request(url, data=json.dumps(data).encode('utf-8'), headers={'Content-Type': 'application/json'})
        with urllib.request.urlopen(req, timeout=15) as response:
            result = json.loads(response.read().decode('utf-8'))
            command = result.get('response', '').strip()
            if command.startswith('```') and command.endswith('```'):
                command = command.strip('`').strip()
                if command.startswith('bash'):
                    command = command[4:].strip()
            return command
    except Exception:
        return None


def getch() -> str:
    """Read a single keypress (Unix)."""
    import termios, tty
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(sys.stdin.fileno())
        ch = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    return ch


def copy_to_clipboard(text: str) -> bool:
    """Copy text to the system clipboard."""
    try:
        if sys.platform == "darwin":
            subprocess.run(["pbcopy"], input=text.encode("utf-8"), check=True, timeout=5)
            return True
        elif sys.platform.startswith("linux"):
            try:
                subprocess.run(["xclip", "-selection", "clipboard"], 
                             input=text.encode("utf-8"), check=True, timeout=5)
                return True
            except FileNotFoundError:
                subprocess.run(["xsel", "--clipboard", "--input"], 
                             input=text.encode("utf-8"), check=True, timeout=5)
                return True
    except FileNotFoundError:
        print_err("No clipboard utility found. Install xclip or xsel on Linux.")
    except subprocess.TimeoutExpired:
        print_err("Clipboard operation timed out.")
    except Exception as e:
        print_err(f"Failed to copy to clipboard: {e}")
    return False


def run_ollama(query: str):
    """Explicitly ask Ollama to generate a command."""
    model = get_ollama_model()
    if not model:
        return

    cmd = ask_ollama(query, model)
    if cmd:
        if RICH_AVAILABLE:
            console.print(Panel(f"[bold green]{cmd}[/bold green]",
                               title=f"🤖 AI Suggestion ({model})",
                               box=box.ROUNDED, expand=False))
            console.print("[dim]Press [bold]Enter[/bold] to run, [bold]Esc[/bold] to cancel, [bold]c[/bold] to copy...[/dim]")
        else:
            print(f"\n--- AI Suggestion ({model}) ---")
            print(f"  {cmd}")
            print("Press Enter to run, Esc to cancel, or c to copy...")

        while True:
            ch = getch()
            if ch == '\r' or ch == '\n':
                print_info(f"Running: {cmd}")
                os.system(cmd)
                return
            elif ch == '\x1b':
                print_info("Cancelled.")
                return
            elif ch.lower() == 'c':
                copy_to_clipboard(cmd)
                print_info("Copied to clipboard.")
                return


def best_guess(query: str, registry: Dict[str, Dict[str, str]]) -> None:
    """Finds the best matching command for the given query and presents it."""
    stats = load_stats()
    config = load_config()
    auto_copy = config.get("auto_copy_to_clipboard", True)

    scores = []
    for key, data in registry.items():
        s = score_match(query, key, data["cmd"], data["desc"])
        if s > 0:
            s += min(200, stats.get(key, 0) * 10)
            scores.append((s, key, data))

    scores.sort(key=lambda x: x[0], reverse=True)

    if not scores or scores[0][0] < 150:
        print_warn(f"No strong match found for: '{query}'")
        print_info("Try interactive search, use -a to add it, or use -o to ask AI.")
        return

    best_match = scores[0]

    if RICH_AVAILABLE:
        panel_content = Text()
        panel_content.append(f"{best_match[1]}\n", style="bold green")
        panel_content.append(f"runs:  ", style="dim")
        panel_content.append(f"{best_match[2]['cmd']}\n")
        panel_content.append(f"what:  ", style="dim")
        panel_content.append(f"{best_match[2]['desc']}")

        console.print(Panel(panel_content, 
                           title=f"Ghee best guess for [bold cyan]'{query}'", 
                           expand=False, box=box.ROUNDED))

        if len(scores) > 1:
            console.print("  [dim]see also:[/dim]")
            for i in range(1, min(5, len(scores))):
                console.print(f"    [yellow]{scores[i][1]:<16}[/yellow] {scores[i][2]['desc']}")
            console.print()
    else:
        print(f"\n--- Ghee best guess for '{query}' ---")
        print(f"  {best_match[1]}")
        print(f"  runs:  {best_match[2]['cmd']}")
        print(f"  what:  {best_match[2]['desc']}\n")
        if len(scores) > 1:
            print("  see also:")
            for i in range(1, min(5, len(scores))):
                print(f"    {scores[i][1]:<16} {scores[i][2]['desc']}")
            print()

    if RICH_AVAILABLE:
        console.print("[dim]Press [bold]Enter[/bold] to copy, [bold]r[/bold] to run, [bold]Esc[/bold] to cancel...[/dim]")
        
        while True:
            ch = getch()
            if ch == '\r' or ch == '\n':
                if auto_copy:
                    copy_to_clipboard(best_match[1])
                    print_info(f"Copied '{best_match[1]}' to clipboard.")
                    record_usage(best_match[1])
                return
            elif ch.lower() == 'r':
                print_info(f"Running: {best_match[2]['cmd']}")
                os.system(best_match[2]['cmd'])
                record_usage(best_match[1])
                return
            elif ch == '\x1b':
                print_info("Cancelled.")
                return
    else:
        if auto_copy:
            copy_to_clipboard(best_match[1])
            print_info(f"Copied '{best_match[1]}' to clipboard.")
            record_usage(best_match[1])


def interactive_mode(registry: Dict[str, Dict[str, str]]) -> None:
    """A Rich-powered interactive REPL for fuzzy finding commands."""
    if not RICH_AVAILABLE:
        print_err("Interactive mode requires 'rich'. Please install it: pip install rich")
        print_info("Falling back to listing all commands.")
        for k, v in registry.items():
            print(f"{k:<15} {v['desc']}")
        return

    from rich.prompt import Prompt
    stats = load_stats()

    console.clear()
    console.print(Panel("[bold magenta]Ghee[/bold magenta] - Interactive Shell\nType to search, or 'quit' to exit.", box=box.ROUNDED, expand=False))

    while True:
        try:
            query = Prompt.ask("\n[bold cyan]>[/bold cyan] Search")
            if query.lower() in ['q', 'quit', 'exit']:
                break

            scores = []
            for key, data in registry.items():
                s = score_match(query, key, data["cmd"], data["desc"])
                if not query:
                    s = 1
                if s > 0:
                    s += min(200, stats.get(key, 0) * 10)
                    scores.append((s, key, data))

            scores.sort(key=lambda x: x[0], reverse=True)

            table = Table(box=box.SIMPLE_HEAD, show_header=False)
            table.add_column("Command", style="bold green")
            table.add_column("Runs", style="dim")
            table.add_column("Description", style="white")

            for s, key, data in scores[:15]:
                table.add_row(key, data["cmd"], data["desc"])

            console.print(table)

            if len(scores) > 15:
                console.print(f"[dim]... and {len(scores) - 15} more matches.[/dim]")

        except (KeyboardInterrupt, EOFError):
            break


def sync_custom(gist_url: Optional[str] = None) -> None:
    """Sync custom commands from a GitHub Gist."""
    import urllib.request
    
    sync_file = Path.home() / ".ghee-sync.json"

    if not gist_url:
        if sync_file.exists():
            try:
                gist_url = json.loads(sync_file.read_text()).get("gist_url")
            except (json.JSONDecodeError, IOError) as e:
                print_err(f"Failed to read sync file: {e}")
                return
        if not gist_url:
            print_err("No Gist URL provided or saved. Usage: g --sync <gist_url>")
            return

    print_info(f"Syncing custom shortcuts from {gist_url}...")

    try:
        if "gist.github.com" in gist_url and "/raw" not in gist_url:
            gist_url = gist_url.rstrip("/") + "/raw"

        req = urllib.request.Request(gist_url)
        with urllib.request.urlopen(req, timeout=10) as response:
            content = response.read().decode('utf-8')

            with open(CUSTOM_FILE, "w") as f:
                f.write(content)

            sync_file.write_text(json.dumps({"gist_url": gist_url}, indent=2))
            print_ok("Custom shortcuts synced successfully.")
    except urllib.error.URLError as e:
        print_err(f"Failed to fetch Gist: {e}")
    except IOError as e:
        print_err(f"Failed to write custom file: {e}")
    except Exception as e:
        print_err(f"Failed to sync: {e}")


def get_modules_info() -> List[Dict[str, str]]:
    """Get information about all ghee modules."""
    modules = []
    
    script_dir = Path(__file__).parent.parent.parent
    modules_dir = script_dir / "modules"
    if not modules_dir.exists():
        modules_dir = Path.cwd() / "modules"

    if not modules_dir.exists():
        return modules

    for mod_file in sorted(modules_dir.glob("*.sh")):
        content = mod_file.read_text()
        # Try to extract module description from comments
        desc_match = re.search(r'#\s*Module:\s*(.*)', content)
        desc = desc_match.group(1).strip() if desc_match else mod_file.stem.replace('_', ' ').title()
        
        modules.append({
            "id": mod_file.stem,
            "name": mod_file.stem.replace('_', ' ').title(),
            "desc": desc,
        })

    return modules


def show_help():
    """Show help with list of modules."""
    if RICH_AVAILABLE:
        console.print(Panel("[bold magenta]Ghee[/bold magenta] - Shell Shortcut Manager", expand=False, box=box.ROUNDED))
        console.print("\n[bold]Usage:[/bold]")
        console.print("  [cyan]g[/cyan]                  Interactive fuzzy search")
        console.print("  [cyan]g <query>[/cyan]          Fuzzy search for a specific command")
        console.print("  [cyan]g -a <cmd> <desc>[/cyan]  Add a custom command")
        console.print("  [cyan]g -o <idea>[/cyan]         Ask Ollama AI to generate a command")
        console.print("  [cyan]g --sync <url>[/cyan]     Sync custom commands from a Gist")
        console.print("  [cyan]g info <module>[/cyan]    Show aliases for a specific module")
        console.print("  [cyan]g --help[/cyan]           Show this help message")

        console.print("\n[bold]Available Modules:[/bold]")
        table = Table(box=box.SIMPLE_HEAD, show_header=True)
        table.add_column("ID", style="cyan")
        table.add_column("Name", style="bold")
        table.add_column("Description", style="dim")

        for mod in get_modules_info():
            table.add_row(mod["id"], mod["name"], mod["desc"])

        console.print(table)
    else:
        print("Ghee - Shell Shortcut Manager")
        print("Usage: g [query | -o <idea> | -a <cmd> <desc> | --sync <url> | info <module> | --help]")
        print("\nAvailable Modules:")
        for mod in get_modules_info():
            print(f"  {mod['id']:<20} {mod['desc']}")


def show_module_info(module_id: str, registry: Dict[str, Dict[str, str]]):
    """Show aliases for a specific module."""
    aliases = []
    for key, data in registry.items():
        if data.get("module") == module_id:
            aliases.append((key, data["cmd"], data["desc"]))

    if not aliases:
        print_err(f"Module '{module_id}' not found or empty.")
        return

    aliases.sort(key=lambda x: x[0])

    if RICH_AVAILABLE:
        console.print(Panel(f"[bold magenta]Module: {module_id}[/bold magenta]", expand=False, box=box.ROUNDED))
        table = Table(box=box.SIMPLE_HEAD, show_header=True)
        table.add_column("Alias", style="bold green")
        table.add_column("Command", style="cyan")
        table.add_column("Description", style="dim")

        for alias, cmd, desc in aliases:
            table.add_row(alias, cmd, desc)

        console.print(table)
    else:
        print(f"--- Module: {module_id} ---")
        for alias, cmd, desc in aliases:
            print(f"  {alias:<15} {cmd:<30} {desc}")


def main():
    """Main entry point for ghee-cli."""
    args = sys.argv[1:]

    if args and args[0] in ('--help', '-h'):
        show_help()
        sys.exit(0)

    registry = load_registry()

    if not args:
        interactive_mode(registry)
    elif args[0] == "info":
        if len(args) < 2:
            print_err("Usage: g info <module>")
            sys.exit(1)
        show_module_info(args[1], registry)
    elif args[0] == "-o":
        if len(args) < 2:
            print_err("Usage: g -o 'your idea'")
            sys.exit(1)
        run_ollama(" ".join(args[1:]))
    elif args[0] == "-a":
        if len(args) < 3:
            print_err("Usage: g -a 'command' 'description'")
            sys.exit(1)
        alias_cmd = args[1]
        desc = " ".join(args[2:])
        add_custom(alias_cmd, desc)
    elif args[0] == "--sync":
        url = args[1] if len(args) > 1 else None
        sync_custom(url)
    else:
        query = " ".join(args)
        best_guess(query, registry)


if __name__ == "__main__":
    main()
