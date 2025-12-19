# git-goblin
Git Scripts that Get the Job Done!

![ggob.jpeg](ggob.jpeg)

A collection of productivity-enhancing git scripts and utilities for developers who want to streamline their workflow.

## Installation

Navigate your terminal to the git-goblin root directory:

```bash
cd /path/to/git-goblin
echo "$(pwd)/scriptname"  # Note the path for the next step
```

Add aliases to your shell configuration:

```bash
nano ~/.bashrc  # OR nano ~/.zshrc
```

Add an alias line like this:
```bash
alias myalias='/path/to/git-goblin/scriptname'
```

Apply the changes and make executable:
```bash
source ~/.bashrc  # OR source ~/.zshrc
chmod +x /path/to/git-goblin/scriptname
```

You're good to go!

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

Executes: `git clone https://www.github.com/username/repo`

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

Executes: `git clone https://www.github.com/juleshenry/reponame`

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

**Usage:**
```bash
./date-file-maker
```

Creates a file like: `12-19-25-14:35:22.txt`

### swap
Swaps the names of two files.

**Usage:**
```bash
# First, define the function (or add to your .bashrc/.zshrc)
swap () {
  tmp_name=$(TMPDIR=$(dirname -- "$1") mktemp) &&
  mv -f -- "$1" "$tmp_name" &&
  mv -f -- "$2" "$1" &&
  mv -f -- "$tmp_name" "$2"
}

# Then use it
swap file1.txt file2.txt
```

### rename_recursively.py
Recursively renames all files in a directory to their last 5 characters.

**⚠️ Use with caution** - This can make files hard to identify!

**Usage:**
```bash
python3 rename_recursively.py /path/to/directory
```

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
3. Different parameters: Function executes and new result is cached with different key

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
- Only serializable types are cached (int, str, float)

**Use Cases:**
- Expensive computations with repeated inputs
- API calls with same parameters
- Data processing pipelines
- Machine learning model predictions

## License
See [LICENSE](LICENSE) file for details.

