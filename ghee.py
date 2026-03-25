#!/usr/bin/env python3
import os
import sys
import re
import subprocess
from pathlib import Path

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
    def print_err(msg): print(f"[ERR] {msg}", file=sys.stderr)
    def print_ok(msg): print(f"[ok] {msg}")
    def print_info(msg): print(f"[..] {msg}")
    def print_warn(msg): print(f"[WARNING] {msg}")
else:
    console = Console()
    def print_err(msg): console.print(f"[bold red][ERR][/bold red] {msg}", err=True)
    def print_ok(msg): console.print(f"[bold green][ok][/bold green] {msg}")
    def print_info(msg): console.print(f"[bold cyan][..][/bold cyan] {msg}")
    def print_warn(msg): console.print(f"[bold yellow][WARNING][/bold yellow] {msg}")

CUSTOM_FILE = Path.home() / ".ghee-custom"

def load_registry():
    """Load built-in commands from ghee modules and custom commands."""
    registry = {}
    
    script_dir = Path(__file__).parent.absolute()
    modules_dir = script_dir / "modules"
    
    if modules_dir.exists():
        for mod_file in modules_dir.glob("*.sh"):
            content = mod_file.read_text()
            matches = re.finditer(r'_GG_REGISTRY\["(.*?)"\]="(.*?)\|\|\|(.*?)"', content)
            for m in matches:
                key = m.group(1).strip()
                cmd = m.group(2).strip()
                desc = m.group(3).strip()
                registry[key] = {"cmd": cmd, "desc": desc}
            
    # Load custom
    if CUSTOM_FILE.exists():
        for line in CUSTOM_FILE.read_text().splitlines():
            if "|||" in line:
                parts = line.split("|||")
                if len(parts) >= 3:
                    # format: key|||cmd|||desc
                    registry[parts[0].strip()] = {
                        "cmd": parts[1].strip(),
                        "desc": parts[2].strip()
                    }
    return registry

def add_custom(alias, desc):
    cmd = alias # In the bash version, the shortcut runs itself? No, G -a 'npm run dev' 'desc' makes alias='npm run dev' and cmd='npm run dev'
    with open(CUSTOM_FILE, "a") as f:
        f.write(f"{alias}|||{cmd}|||{desc}\n")
    print_ok(f"Added: [bold]{alias}[/bold] -- {desc}" if RICH_AVAILABLE else f"Added: {alias} -- {desc}")
    print_info(f"Saved to {CUSTOM_FILE}")

def score_match(query, key, cmd, desc):
    """Recreate the word-overlap scoring from the bash version but better."""
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

def best_guess(query, registry):
    best_key = None
    best_score = 0
    
    scores = []
    for key, data in registry.items():
        s = score_match(query, key, data["cmd"], data["desc"])
        if s > 0:
            scores.append((s, key, data))
            
    if not scores:
        print_warn(f"No match found for: '{query}'")
        print_info("Try interactive search or use -a to add it.")
        return
        
    scores.sort(key=lambda x: x[0], reverse=True)
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

def interactive_mode(registry):
    """A rich REPL for fuzzy finding."""
    if not RICH_AVAILABLE:
        print_err("Interactive mode requires 'rich'. Please install it: pip install rich")
        print_info("Falling back to listing all commands.")
        for k, v in registry.items():
            print(f"{k:<15} {v['desc']}")
        return

    from rich.prompt import Prompt
    
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

def main():
    args = sys.argv[1:]
    registry = load_registry()
    
    if not args:
        interactive_mode(registry)
    elif args[0] == "-a":
        if len(args) < 3:
            print_err("Usage: G -a 'command' 'description'")
            sys.exit(1)
        alias_cmd = args[1]
        desc = " ".join(args[2:])
        add_custom(alias_cmd, desc)
    else:
        query = " ".join(args)
        best_guess(query, registry)

if __name__ == "__main__":
    main()
