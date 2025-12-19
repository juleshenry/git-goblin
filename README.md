# git-goblin
Git Scripts that Get the Job Done!

![ggob.jpeg](ggob.jpeg)

To add any script to your path... for example, gacp.

Navigate your terminal to the gitgoblin root.
`echo "$(pwd)\gacp`
`nano ~/.bashrc OR nano ~/.zshrc`
`alias myalias='$PATH_TO_GITGOBLIN/git-goblin-gacp'` 
`source ~/.bashrc OR source ~/.zshrc` 
`chmod 700 gacp`
GOOD TO GO!

# gg
## (aka 'gacp' aka 'gush')
Simplifies clunky common pattern of adding all changes, committing and pushing.
E.g. `gg "New Form on HomePage"`

# h 
## (history|grep $1)
would you like to grep history on the fly? `h` that joint!!

# autosave-git-recursively.py
When called, recurses all child folders and git pushes with the message "Autosave $GMT_DateTime"

# git-goblin.py
pipe this into .$$rc to quickly initialize git-goblin

# date-file-maker
Makes a text file of as $GMT_DateTime.txt

# ds-store-duster
Recurses all child folders and removes .DS_Store

# dust-kash
Recurses all child folders and removes .kash

# kash
Python decorator that caches results based on parameters

# mega_script.sh
**100 Useful Git Aliases and File Management Routines!** 🚀

A comprehensive collection of Git shortcuts and utilities organized into categories:
- **Basic Git Operations** (15 aliases): Quick commands for add, commit, push, pull
- **Branching** (15 aliases): Branch creation, deletion, switching, and merging
- **Logging & History** (15 aliases): Beautiful logs, blame, reflog, and search
- **Diff & Inspection** (15 aliases): Compare changes, inspect files, view contributors
- **Stashing** (10 aliases): Save and restore work in progress
- **Remote Operations** (10 aliases): Manage remotes, fetch, clone
- **Reset & Clean** (10 aliases): Undo changes, clean workspace
- **Advanced Operations** (10 aliases): Cherry-pick, rebase, tags
- **25+ Utility Functions**: Complex workflows like `ginit()`, `gquick()`, `gsyncfork()`, `gstats()`
- **File Management**: Remove .DS_Store, find large files, backup repos

## Usage
Source the script in your shell:
```bash
source mega_script.sh
```

Or add to your `~/.bashrc` or `~/.zshrc`:
```bash
echo "source $(pwd)/mega_script.sh" >> ~/.bashrc
source ~/.bashrc
```

## Examples
- `gs` - Quick git status
- `gacp "commit message"` - Add, commit, and push in one command
- `glog` - Beautiful commit history graph
- `ginfo` - Show repository information
- `galias` - List all available Git aliases
- `gquick` - Commit and push with automatic timestamp

