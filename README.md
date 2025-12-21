# git-goblin
Git Scripts that Get the Job Done!

![ggob.jpeg](ggob.jpeg)

## Quick Setup (Recommended)

Run the automated setup script:

```bash
cd /path/to/git-goblin
./setup-git-goblin
```

This script will:
- Detect your shell (bash/zsh)
- Add a source line to your RC file (.bashrc/.zshrc) to load git-goblin bash functions
- Make Python scripts executable
- Create a backup of your RC file before making changes
- Migrate old alias-based configurations to the new bash function approach

After running the setup script, all git-goblin commands will be available as bash functions in your shell.

## Manual Setup

If you prefer to set up manually or want to customize your setup:

### Option 1: Source all functions at once (Recommended)

Add the source line to your shell configuration:

```bash
# For bash users
echo 'source /path/to/git-goblin/git-goblin-functions.sh' >> ~/.bashrc
source ~/.bashrc

# For zsh users
echo 'source /path/to/git-goblin/git-goblin-functions.sh' >> ~/.zshrc
source ~/.zshrc
```

Replace `/path/to/git-goblin` with the actual path to your git-goblin directory.

### Option 2: Source individual scripts

You can also source individual scripts as needed:

```bash
# For bash users
echo 'source /path/to/git-goblin/hl' >> ~/.bashrc
source ~/.bashrc

# For zsh users  
echo 'source /path/to/git-goblin/hl' >> ~/.zshrc
source ~/.zshrc
```

This approach is useful if you only want specific git-goblin commands available in your shell.

**Note:** The old alias-based approach has been replaced with bash functions for better shell environment compatibility. All scripts can now be:
- **Sourced** to define bash functions in your current shell
- **Executed directly** as standalone scripts (backward compatible)

# setup-git-goblin
Automated setup script that configures git-goblin for your environment. Detects your shell (bash/zsh), adds a source line to load bash functions from the appropriate RC file, makes Python scripts executable, and provides helpful feedback throughout the process. Automatically migrates old alias-based configurations to the new bash function approach.

# gg
## (aka 'gacp' aka 'gush')
Simplifies clunky common pattern of adding all changes, committing and pushing.
E.g. `gg "New Form on HomePage"`
A collection of productivity-enhancing git scripts and utilities for developers who want to streamline their workflow.

## Installation

The recommended way to install git-goblin is using the automated setup script:

```bash
cd /path/to/git-goblin
./setup-git-goblin
```

This will configure your shell to load git-goblin bash functions automatically.

Alternatively, you can manually add this line to your shell configuration:

```bash
# Add to ~/.bashrc or ~/.zshrc
source /path/to/git-goblin/git-goblin-functions.sh
```

Then reload your shell:
```bash
source ~/.bashrc  # OR source ~/.zshrc
```

All git-goblin commands are now available as bash functions!

## Git Workflow Scripts

### gg
**Aliases:** gacp, gush

Simplifies the common pattern of adding all changes, committing, and pushing in one command.

**Usage:**
```bash
gg "Your commit message"
```

**Example:**
```bash
gg "New Form on HomePage"
```

This executes:
```bash
git add .
git commit -m "Your commit message"
git push
```

### gclo
Git clone shortcut for quickly cloning repositories.

**Usage:**
```bash
gclo username/repo
```

**Example:**
```bash
gclo torvalds/linux
```

Executes: `git clone https://github.com/username/repo`

### jclo
Quick clone for juleshenry's repositories specifically.

**Usage:**
```bash
jclo reponame
```

**Example:**
```bash
jclo git-goblin
```

Executes: `git clone https://github.com/juleshenry/reponame`

### presto
**⚠️ Use with extreme caution!**

Deletes all git history and starts fresh. This is a destructive operation.

**What it does:**
- Creates a new orphan branch
- Commits all current files
- Deletes the main branch
- Renames the orphan branch to main
- Force pushes to origin

### autosave-git-recursively.py
Recursively searches for all git repositories in child directories and automatically commits and pushes them with a timestamp.

**Usage:**
```bash
python3 autosave-git-recursively.py
```

Commits are made with the message: `Autosaving... [timestamp]`

## Shell History Utilities

### h
**Command:** `history | grep $1`

Grep your shell history on the fly!

**Usage:**
```bash
h searchterm
```

**Example:**
```bash
h docker  # Shows all history entries containing "docker"
```

### hl
**History-grep "I'm feeling lucky" prompt**

Finds the penultimate match from history and prompts you to execute it.

**Usage:**
```bash
hl searchterm
```

The script will:
1. Find the second-to-last history match
2. Display it
3. Prompt you to press Enter to execute or Ctrl+C to cancel

## File Management Utilities

### ds-store-duster
Recursively finds and removes all `.DS_Store` files (macOS metadata files) from the current directory and subdirectories.

**Usage:**
```bash
./ds-store-duster
```

### dust-kash
Recursively finds and removes all `.kash` cache files created by the kash decorator.

**Usage:**
```bash
./dust-kash
```

### date-file-maker
Creates an empty text file with a UTC timestamp as the filename.

**⚠️ Script Issue:** The script currently has a bug with conflicting date format options (`-R` and a custom format string). 

**To fix:** Edit the script and change line 3 from:
```bash
touch "$(date -u -R '+%m-%d-%y-%H:%M:%S').txt"
```
to:
```bash
touch "$(date -u '+%m-%d-%y-%H:%M:%S').txt"
```

**Usage (after fix):**
```bash
./date-file-maker
```

**Output:** Creates a file like `12-19-25-14:35:22.txt`

### swap
Prints a bash function that swaps the names of two files.

**Usage:**
```bash
# The script prints the function code, which you can:
# 1. Copy and paste into your terminal, or
# 2. Add to your .bashrc/.zshrc, or
# 3. Evaluate directly:
eval "$(./swap)"

# Then use it:
swap file1.txt file2.txt
```

**The function it provides:**
```bash
swap () {
  tmp_name=$(TMPDIR=$(dirname -- "$1") mktemp) &&
  mv -f -- "$1" "$tmp_name" &&
  mv -f -- "$2" "$1" &&
  mv -f -- "$tmp_name" "$2"
}
```

### rename_recursively.py
Recursively renames all files in a directory to their last 5 characters. Files with names shorter than 5 characters will keep their full filename.

**⚠️ Use with extreme caution** - This destructively renames all files and can make them hard to identify!

**Usage:**
```bash
python3 rename_recursively.py /path/to/directory
```

**Example:**
- `my_document.pdf` → `t.pdf` (last 5 chars: "t.pdf")
- `hello.txt` → `o.txt` (last 5 chars: "o.txt")
- `ab.py` → `ab.py` (only 5 chars total, keeps full name)

### file_ext_and_cnt
Prints a count of files grouped by their extension.

**Usage:**
```bash
./file_ext_and_cnt
```

Executes: `find . -type f | sed -n 's/..*\.//p' | sort | uniq -c`

### pdf-to-svg
Batch converts all PDF files in the current directory to SVG format using Inkscape.

**Requirements:** Inkscape must be installed.

**Usage:**
```bash
./pdf-to-svg
```

### tru_shufl
A true random shuffle implementation using Python's secrets module (cryptographically strong).

**Usage:**
```bash
python3 tru_shufl
```

Generates a shuffled list of numbers from 1 to 52 (useful for card games, etc.)

## Development Utilities

### blk
Runs Python Black formatter on a specified file.

**Usage:**
```bash
blk filename.py
```

### git-goblin.py
Generates shell alias commands for git-goblin scripts. Pipe the output into your `.bashrc` or `.zshrc` to quickly initialize git-goblin aliases.

**Usage:**
```bash
python3 git-goblin.py >> ~/.zshrc
source ~/.zshrc
```

### repoinspector.py
Fetches and displays all open issues across a GitHub user's repositories.

**Requirements:** `requests` library (`pip install requests`)

**Usage:**
```bash
python3 repoinspector.py [username]
```

**Example:**
```bash
python3 repoinspector.py juleshenry
```

If no username is provided, defaults to "juleshenry".

### repolist.sh
Lists all GitHub repositories for a user (requires GitHub CLI).

**Usage:**
```bash
./repolist.sh
```

Executes: `gh repo list juleshenry --limit 1000`

## Python Utilities

### kash
**A Python decorator for caching function results based on parameters.**

The `kash` decorator caches function results to `.kash` files (JSON format) based on the function's arguments. When the function is called again with the same parameters, the cached result is returned instead of re-executing the function.

**How it works:**
1. First call with specific parameters: Function executes and result is cached to `filename.kash`
2. Subsequent calls with same parameters: Cached result is returned immediately
3. Different parameters (int, str, or float): Function executes and new result is cached with different key
4. **Note:** Only int, str, and float arguments affect the cache key; other types are ignored

**Basic Usage:**
```python
from kash import kash

@kash("my_cache")  # Creates my_cache.kash file
def expensive_function(x, y):
    # Some time-consuming operation
    result = x ** y
    return result

# First call - executes function
print(expensive_function(2, 10))  # Computes and caches

# Second call with same args - uses cache
print(expensive_function(2, 10))  # Returns cached result instantly

# Different args - executes function
print(expensive_function(3, 10))  # Computes and caches new result
```

**Class Methods:**
```python
class MyClass:
    @kash("class_cache")
    def expensive_method(self, param):
        # Heavy computation
        return result
```

**Cache Management:**
- Cache files are stored as JSON with `.kash` extension
- To clear cache: delete the `.kash` files or use `./dust-kash`
- **Cache key limitation:** Only int, str, and float arguments are used to generate cache keys
- Other argument types (bool, list, dict, objects) are filtered out and won't affect caching
- This means functions called with different complex objects will incorrectly return the same cached result

**Use Cases:**
- Expensive computations with repeated inputs
- API calls with same parameters
- Data processing pipelines
- Machine learning model predictions

## License
See [LICENSE](LICENSE) file for details.

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

