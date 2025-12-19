#!/bin/bash
# mega_script.sh - 100 Useful Git Aliases and File Management Routines
# Usage: source mega_script.sh OR add to your ~/.bashrc or ~/.zshrc

# ============================================================================
# BASIC GIT OPERATIONS (1-15)
# ============================================================================

# 1. Quick add, commit, push (use as function - see below)

# 2. Quick status
alias gs='git status'

# 3. Quick status with short format
alias gss='git status -s'

# 4. Add all changes
alias ga='git add .'

# 5. Add specific file
alias gaf='git add'

# 6. Commit with message
alias gc='git commit -m'

# 7. Commit all tracked files
alias gca='git commit -a -m'

# 8. Amend last commit
alias gcam='git commit --amend -m'

# 9. Amend without changing message
alias gcan='git commit --amend --no-edit'

# 10. Push to origin
alias gp='git push'

# 11. Push with force
alias gpf='git push --force'

# 12. Push with force (safer)
alias gpfl='git push --force-with-lease'

# 13. Push and set upstream
alias gpu='git push -u origin'

# 14. Pull from origin
alias gl='git pull'

# 15. Pull with rebase
alias glr='git pull --rebase'

# 16. Pull and prune
alias glp='git pull --prune'

# ============================================================================
# BRANCHING (17-30)
# ============================================================================

# 17. List branches
alias gb='git branch'

# 18. List all branches (including remote)
alias gba='git branch -a'

# 19. Create new branch
alias gbn='git branch'

# 20. Delete branch
alias gbd='git branch -d'

# 21. Force delete branch
alias gbdf='git branch -D'

# 22. Checkout branch
alias gco='git checkout'

# 23. Checkout new branch
alias gcob='git checkout -b'

# 24. Checkout previous branch
alias gcop='git checkout -'

# 25. Checkout master/main
alias gcom='git checkout main || git checkout master'

# 26. Switch to branch (newer syntax)
alias gsw='git switch'

# 27. Create and switch to new branch
alias gswc='git switch -c'

# 28. Merge branch
alias gm='git merge'

# 29. Merge with no fast-forward
alias gmnf='git merge --no-ff'

# 30. Abort merge
alias gma='git merge --abort'

# 31. Show merged branches
alias gbm='git branch --merged'

# ============================================================================
# LOGGING AND HISTORY (32-46)
# ============================================================================

# 32. Pretty log
alias glog='git log --oneline --decorate --graph'

# 33. Pretty log with all branches
alias gloga='git log --oneline --decorate --graph --all'

# 34. Log with dates
alias glogd='git log --pretty=format:"%h %ad %s" --date=short'

# 35. Log with stats
alias glogs='git log --stat'

# 36. Log with patch
alias glogp='git log -p'

# 37. Show last commit
alias glast='git log -1 HEAD'

# 38. Show who changed what
alias gblame='git blame'

# 39. Show changes in last commit
alias gshow='git show'

# 40. Show file at specific commit (requires commit:file argument)
alias gshowf='git show'

# 41. List commits by author
alias gauthor='git log --author'

# 42. Search commits
alias gsearch='git log --all --grep'

# 43. Show branches with last commit
alias gbv='git branch -v'

# 44. Show branches with more info
alias gbvv='git branch -vv'

# 45. Reflog
alias grl='git reflog'

# 46. Short reflog
alias grls='git reflog --pretty=short'

# ============================================================================
# DIFF AND INSPECTION (47-61)
# ============================================================================

# 47. Show diff
alias gd='git diff'

# 48. Show diff of staged files
alias gds='git diff --staged'

# 49. Show diff with stats
alias gdst='git diff --stat'

# 50. Show diff of specific file (requires file argument)
alias gdf='git diff'

# 51. Show word diff
alias gdw='git diff --word-diff'

# 52. Show diff between branches (requires branch arguments)
alias gdb='git diff'

# 53. Show files changed
alias gdfiles='git diff --name-only'

# 54. Show files changed with status
alias gdstat='git diff --name-status'

# 55. Show diff in color
alias gdc='git diff --color-words'

# 56. Show what changed in last commit
alias gdlc='git diff HEAD^ HEAD'

# 57. List tracked files
alias gls='git ls-files'

# 58. List untracked files
alias glsu='git ls-files --others'

# 59. Show file content at commit (requires commit:file argument)
alias gcat='git show'

# 60. Show contributors
alias gcontrib='git shortlog -sn'

# 61. Show file history
alias gfh='git log --follow -p --'

# ============================================================================
# STASHING (62-71)
# ============================================================================

# 62. Stash changes
alias gst='git stash'

# 63. Stash with message
alias gstm='git stash save'

# 64. Stash including untracked
alias gstu='git stash -u'

# 65. Stash all (including ignored)
alias gsta='git stash -a'

# 66. List stashes
alias gstl='git stash list'

# 67. Show stash content
alias gsts='git stash show -p'

# 68. Apply last stash
alias gstap='git stash apply'

# 69. Pop last stash
alias gstpo='git stash pop'

# 70. Drop stash
alias gstd='git stash drop'

# 71. Clear all stashes
alias gstc='git stash clear'

# ============================================================================
# REMOTE OPERATIONS (72-81)
# ============================================================================

# 72. Show remotes
alias gr='git remote'

# 73. Show remotes with URLs
alias grv='git remote -v'

# 74. Add remote
alias gra='git remote add'

# 75. Remove remote
alias grr='git remote remove'

# 76. Rename remote
alias grrm='git remote rename'

# 77. Fetch from origin
alias gf='git fetch'

# 78. Fetch all remotes
alias gfa='git fetch --all'

# 79. Fetch with prune
alias gfp='git fetch --prune'

# 80. Clone repository
alias gcl='git clone'

# 81. Clone with depth
alias gcld='git clone --depth 1'

# ============================================================================
# RESET AND CLEAN (82-91)
# ============================================================================

# 82. Reset to last commit (soft)
alias grss='git reset --soft HEAD~1'

# 83. Reset to last commit (mixed)
alias grsm='git reset HEAD~1'

# 84. Reset to last commit (hard)
alias grsh='git reset --hard HEAD~1'

# 85. Reset to origin
alias grso='git reset --hard origin/$(git branch --show-current)'

# 86. Unstage all files
alias gus='git reset HEAD'

# 87. Unstage specific file (requires file argument after --)
alias gusf='git reset HEAD --'

# 88. Clean untracked files (dry run)
alias gcn='git clean -n'

# 89. Clean untracked files
alias gcf='git clean -f'

# 90. Clean untracked files and directories
alias gcfd='git clean -fd'

# 91. Discard changes in file (requires file argument after --)
alias gdis='git checkout --'

# ============================================================================
# ADVANCED OPERATIONS (92-101)
# ============================================================================

# 92. Cherry-pick commit
alias gcp='git cherry-pick'

# 93. Cherry-pick and continue
alias gcpc='git cherry-pick --continue'

# 94. Cherry-pick abort
alias gcpa='git cherry-pick --abort'

# 95. Rebase interactive
alias grbi='git rebase -i'

# 96. Rebase continue
alias grbc='git rebase --continue'

# 97. Rebase abort
alias grba='git rebase --abort'

# 98. Rebase skip
alias grbs='git rebase --skip'

# 99. Show tags
alias gt='git tag'

# 100. Create tag
alias gta='git tag -a'

# 101. Push tags
alias gpt='git push --tags'

# ============================================================================
# FUNCTIONS - Complex Operations
# ============================================================================

# Quick add, commit, push
gacp() {
    if [ -z "$1" ]; then
        echo "Usage: gacp <commit_message>"
        return 1
    fi
    git add . && git commit -m "$1" && git push
}

# Initialize git repo with initial commit
ginit() {
    git init
    git add .
    git commit -m "Initial commit"
}

# Quick clone from GitHub
ghcl() {
    git clone "https://github.com/$1"
}

# Create branch and switch to it
gbc() {
    git checkout -b "$1"
}

# Delete branch both locally and remotely
gbdall() {
    git branch -d "$1"
    git push origin --delete "$1"
}

# Undo last commit but keep changes
gundo() {
    git reset --soft HEAD~1
}

# Show branches sorted by last modified
gbs() {
    git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:short) %(refname:short)'
}

# Quick commit and push all changes with timestamp
gquick() {
    git add .
    git commit -m "Quick update: $(date '+%Y-%m-%d %H:%M:%S')"
    git push
}

# Show changed files in last N commits
gchanged() {
    git diff --name-only HEAD~${1:-5}..HEAD
}

# Search for text in git history
gsearchtext() {
    git log -S "$1" --pretty=format:"%h %ad %s" --date=short
}

# Create new branch from origin/main
gnew() {
    git fetch origin
    git checkout -b "$1" origin/main
}

# Update current branch from all remotes
gupdateall() {
    git fetch --all
    git pull
}

# Show size of repository
greposize() {
    git count-objects -vH
}

# List files by size
gfilesize() {
    git ls-tree -r -t -l --full-name HEAD | sort -n -k 4
}

# Find large files in history
glarge() {
    local count=${1:-10}
    git rev-list --objects --all | \
        git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | \
        awk '/^blob/ {print substr($0,6)}' | \
        sort --numeric-sort --key=2 | \
        tail -${count}
}

# Sync fork with upstream
gsyncfork() {
    git fetch upstream
    git checkout main
    git merge upstream/main
    git push origin main
}

# Squash last N commits
gsquash() {
    if [ -z "$2" ]; then
        echo "Usage: gsquash <number_of_commits> <commit_message>"
        return 1
    fi
    git reset --soft HEAD~${1:-2}
    git commit -m "$2"
}

# Show commit count by author
gstats() {
    git shortlog -sn --all --no-merges
}

# Archive branch
garchive() {
    git tag archive/"$1" "$1"
    git branch -d "$1"
    git push origin --delete "$1"
    git push origin archive/"$1"
}

# List aliases
galias() {
    alias | grep '^g'
}

# Show git info
ginfo() {
    echo "Repository: $(basename $(git rev-parse --show-toplevel))"
    echo "Branch: $(git branch --show-current)"
    echo "Remote: $(git remote get-url origin 2>/dev/null || echo 'No remote')"
    echo "Last commit: $(git log -1 --pretty=format:'%h - %s (%ar)')"
    echo "Files changed: $(git status -s | wc -l)"
}

# ============================================================================
# FILE MANAGEMENT UTILITIES
# ============================================================================

# Remove .DS_Store files recursively
rmdstore() {
    find . -name ".DS_Store" -type f -delete
    echo "Removed all .DS_Store files"
}

# Remove node_modules recursively
rmnodemodules() {
    echo "Finding node_modules directories..."
    find . -name "node_modules" -type d -prune
    read -p "Remove all node_modules directories? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        find . -name "node_modules" -type d -prune -exec rm -rf {} \;
        echo "Removed all node_modules directories"
    else
        echo "Cancelled"
    fi
}

# Count files by extension
countext() {
    find . -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn
}

# Find large files in directory
findlarge() {
    find . -type f -size +${1:-10M} -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'
}

# Backup git repository
gbackup() {
    local backup_name="git-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    tar -czf "../$backup_name" .
    echo "Backup created: ../$backup_name"
}

# ============================================================================
# UTILITY MESSAGES
# ============================================================================

echo "Git Goblin Mega Script loaded! 🎉"
echo "Type 'galias' to see all Git aliases"
echo "Type 'ginfo' to see current repository info"
