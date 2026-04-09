#!/usr/bin/env python3
"""
ghee.py - Interactive TUI for fuzzy-searching shell commands.

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

    Reads all `.sh` files in the `modules` directory to extract predefined aliases
    and their corresponding commands/descriptions. Also reads `~/.ghee-custom`
    to append any user-defined shortcuts.

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

    script_dir = Path(__file__).parent.absolute()
    modules_dir = script_dir / "modules"

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
                        # format: key|||cmd|||desc
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

        # Check if any module files have been modified since cache was created
        script_dir = Path(__file__).parent.absolute()
        modules_dir = script_dir / "modules"
        if modules_dir.exists():
            for mod_file in modules_dir.glob("*.sh"):
                if mod_file.stat().st_mtime > cache_time:
                    return True

        # Check if custom file was modified
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

def add_custom(alias, desc):
    cmd = alias # In the bash version, the shortcut runs itself? No, g -a 'npm run dev' 'desc' makes alias='npm run dev' and cmd='npm run dev'
    with open(CUSTOM_FILE, "a") as f:
        f.write(f"{alias}|||{cmd}|||{desc}\n")
    print_ok(f"Added: [bold]{alias}[/bold] -- {desc}" if RICH_AVAILABLE else f"Added: {alias} -- {desc}")
    print_info(f"Saved to {CUSTOM_FILE}")

def score_match(query, key, cmd, desc):
    """
    Score the match of a query against a command alias, actual command, and description.
    
    Implements a word-overlap fuzzy scoring algorithm. 
    Higher scores indicate a better match. Exact alias matches get the highest score.
    
    Args:
        query (str): The search string provided by the user.
        key (str): The alias name.
        cmd (str): The underlying shell command.
        desc (str): A description of what the command does.
        
    Returns:
        int: The match score (0 if no match at all).
    """
    query = query.lower()
    key = key.lower()
    cmd = cmd.lower()
    desc = desc.lower()
    
    score = 0
    if cmd == query: score += 1000
    if query in cmd: score += 500
    if cmd in query and cmd: score += 400
    if key == query: score += 900
    
    for word in query.split():
        if word in cmd: score += 50
        if word in desc: score += 30
        if word in key: score += 40
        
    return score

def get_ollama_model():
    import urllib.request
    try:
        req = urllib.request.Request("http://localhost:11434/api/tags")
        with urllib.request.urlopen(req, timeout=2) as response:
            data = json.loads(response.read().decode('utf-8'))
            models = [m['name'] for m in data.get('models', [])]
            for pref in ['llama3.2', 'llama3', 'mistral', 'codellama']:
                for m in models:
                    if m.startswith(pref): return m
            if models: return models[0]
    except Exception:
        pass
    return None

def ask_ollama(query, model):
    import urllib.request
    print_info(f"Asking Ollama ({model}) to generate a command...")
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
    except Exception as e:
        print_err(f"Ollama error: {e}")
        return None

def getch():
    """Read a single keypress (Unix)."""
    import termios, tty, sys
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(sys.stdin.fileno())
        ch = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    return ch

def best_guess(query, registry):
    """
    Finds the best matching command for the given query and presents it.
    
    If it finds matches, it shows the highest-scoring match and up to 4 alternatives.
    It automatically copies the best match command to the user's clipboard.
    
    Args:
        query (str): The search query to look up.
        registry (dict): The loaded command registry containing available aliases.
    """
    best_key = None
    best_score = 0
    stats = load_stats()
    
    scores = []
    for key, data in registry.items():
        s = score_match(query, key, data["cmd"], data["desc"])
        if s > 0:
            # Boost score based on usage frequency (capped at 200 points max)
            s += min(200, stats.get(key, 0) * 10)
            scores.append((s, key, data))
            
    scores.sort(key=lambda x: x[0], reverse=True)
    
    if not scores or scores[0][0] < 150:
        print_warn(f"No strong match found for: '{query}'")
        
        model = get_ollama_model()
        if model:
            cmd = ask_ollama(query, model)
            if cmd:
                if RICH_AVAILABLE:
                    console.print(Panel(f"[bold green]{cmd}[/bold green]", title=f"🤖 AI Suggestion ({model})", box=box.ROUNDED, expand=False))
                    console.print("[dim]Press [bold]Enter[/bold] to run, [bold]Esc[/bold] to cancel, or [bold]c[/bold] to copy...[/dim]")
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
                    elif ch == '\x1b': # Escape
                        print_info("Cancelled.")
                        return
                    elif ch.lower() == 'c':
                        try:
                            if sys.platform == "darwin":
                                subprocess.run(["pbcopy"], input=cmd.encode("utf-8"), check=True)
                                print_info("Copied to clipboard.")
                            elif sys.platform.startswith("linux"):
                                subprocess.run(["xclip", "-selection", "clipboard"], input=cmd.encode("utf-8"), check=True)
                                print_info("Copied to clipboard.")
                        except FileNotFoundError:
                            pass
                        return
        
        print_info("Try interactive search or use -a to add it.")
        return
        
    best_match = scores[0]
    
    if RICH_AVAILABLE:
        panel_content = Text()
        panel_content.append(f"{best_match[1]}\n", style="bold green")
        panel_content.append(f"runs:  ", style="dim")
        panel_content.append(f"{best_match[2]['cmd']}\n")
        panel_content.append(f"what:  ", style="dim")
        panel_content.append(f"{best_match[2]['desc']}")
        
        console.print(Panel(panel_content, title=f"Ghee best guess for [bold cyan]'{query}'", expand=False, box=box.ROUNDED))
        
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

    # Copy to clipboard
    try:
        if sys.platform == "darwin":
            subprocess.run(["pbcopy"], input=best_match[1].encode("utf-8"), check=True)
            print_info(f"Copied '{best_match[1]}' to clipboard (macOS).")
        elif sys.platform.startswith("linux"):
            subprocess.run(["xclip", "-selection", "clipboard"], input=best_match[1].encode("utf-8"), check=True)
            print_info(f"Copied '{best_match[1]}' to clipboard (Linux).")
        except FileNotFoundError:
            pass
        record_usage(best_match[1])

def interactive_mode(registry):
    """
    A Rich-powered interactive Read-Eval-Print Loop (REPL) for fuzzy finding commands.
    
    Provides a real-time search interface, filtering and scoring the registry based
    on user input. Requires the `rich` library.
    
    Args:
        registry (dict): The complete command registry.
    """
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
                # If query is empty, show everything (score=1)
                if not query: s = 1
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

def sync_custom(gist_url=None):
    """
    Sync custom commands from a GitHub Gist.
    If gist_url is not provided, it tries to read the saved URL.
    """
    sync_file = Path.home() / ".ghee-sync.json"
    
    if not gist_url:
        if sync_file.exists():
            gist_url = json.loads(sync_file.read_text()).get("gist_url")
        if not gist_url:
            print_err("No Gist URL provided or saved. Usage: g --sync <gist_url>")
            return
            
    import urllib.request
    print_info(f"Syncing custom shortcuts from {gist_url}...")
    
    try:
        # Convert GitHub Gist UI URL to raw URL if necessary
        if "gist.github.com" in gist_url and "/raw" not in gist_url:
            gist_url = gist_url.rstrip("/") + "/raw"
            
        req = urllib.request.Request(gist_url)
        with urllib.request.urlopen(req, timeout=10) as response:
            content = response.read().decode('utf-8')
            
            with open(CUSTOM_FILE, "w") as f:
                f.write(content)
                
            sync_file.write_text(json.dumps({"gist_url": gist_url}))
            print_ok("Custom shortcuts synced successfully.")
    except Exception as e:
        print_err(f"Failed to sync: {e}")

def main():
    args = sys.argv[1:]
    registry = load_registry()
    
    if not args:
        interactive_mode(registry)
    elif args[0] == "--sync":
        url = args[1] if len(args) > 1 else None
        sync_custom(url)
    elif args[0] == "-a":
        if len(args) < 3:
            print_err("Usage: g -a 'command' 'description'")
            sys.exit(1)
        alias_cmd = args[1]
        desc = " ".join(args[2:])
        add_custom(alias_cmd, desc)
    else:
        query = " ".join(args)
        best_guess(query, registry)

if __name__ == "__main__":
    main()
