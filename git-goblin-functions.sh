#!/bin/bash
# git-goblin-functions.sh
# Bash functions for git-goblin utilities
# Usage: source /path/to/git-goblin/git-goblin-functions.sh

# ============================================================================
# GIT WORKFLOW FUNCTIONS
# ============================================================================

# gg: git add, commit, and push in one command
# Usage: gg "commit message"
gg() {
    git add .
    git commit -m "$1"
    git push
}

# gclo: git clone shortcut
# Usage: gclo username/repo
gclo() {
    git clone "https://www.github.com/$1"
}

# jclo: git clone for juleshenry repositories
# Usage: jclo reponame
jclo() {
    local j=juleshenry
    git clone "https://www.github.com/$j/$1"
}

# presto: Delete all git history - use with extreme caution!
presto() {
    git checkout --orphan annie
    git add -A
    git commit -am 'cm'
    git branch -D main
    git branch -m main
    git push -f origin main
}

# ============================================================================
# SHELL HISTORY FUNCTIONS
# ============================================================================

# h: grep shell history
# Usage: h searchterm
h() {
    history | grep "$1"
}

# hl: history-grep "I'm feeling lucky" prompt
# Usage: hl searchterm
hl() {
    local result=$(history 1 | grep "$1" | tail -n 2 | head -n 1)
    echo "Penultimate match: $result"
    read -p "Press Enter to execute, or Ctrl+C to cancel..."
    eval "$result"
}

# ============================================================================
# FILE MANAGEMENT FUNCTIONS
# ============================================================================

# ds-store-duster: Remove all .DS_Store files recursively
ds-store-duster() {
    find . -type f -name '.DS_Store' -exec rm {} +
}

# dust-kash: Remove all .kash cache files recursively
dust-kash() {
    find . -type f -name '*.kash' -exec rm {} +
}

# date-file-maker: Create a UTC timestamped text file
date-file-maker() {
    touch "$(date -u '+%m-%d-%y-%H:%M:%S').txt"
}

# swap: Swap the names of two files
# Usage: swap file1 file2
swap() {
    local tmp_name=$(TMPDIR=$(dirname -- "$1") mktemp)
    mv -f -- "$1" "$tmp_name"
    mv -f -- "$2" "$1"
    mv -f -- "$tmp_name" "$2"
}

# ============================================================================
# DEVELOPMENT FUNCTIONS
# ============================================================================

# blk: Run Python Black formatter on a file
# Usage: blk filename.py
blk() {
    python3 -m black "$1"
}

# Export functions so they're available in subshells if needed
export -f gg
export -f gclo
export -f jclo
export -f presto
export -f h
export -f hl
export -f ds-store-duster
export -f dust-kash
export -f date-file-maker
export -f swap
export -f blk
