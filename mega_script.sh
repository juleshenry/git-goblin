#!/bin/bash
# mega_script.sh - 100 Useful Git Aliases and File Management Routines
# Usage: source mega_script.sh OR add to your ~/.bashrc or ~/.zshrc

# ============================================================================
# BASIC GIT OPERATIONS (1-15)
# ============================================================================

# 1. Quick add, commit, push
alias gacp='git add . && git commit -m "$1" && git push'

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

# ============================================================================
# BRANCHING (16-30)
# ============================================================================

# 16. List branches
alias gb='git branch'

# 17. List all branches (including remote)
alias gba='git branch -a'

# 18. Create new branch
alias gbn='git branch'

# 19. Delete branch
alias gbd='git branch -d'

# 20. Force delete branch
alias gbdf='git branch -D'

# 21. Checkout branch
alias gco='git checkout'

# 22. Checkout new branch
alias gcob='git checkout -b'

# 23. Checkout previous branch
alias gcop='git checkout -'

# 24. Checkout master/main
alias gcom='git checkout main || git checkout master'

# 25. Switch to branch (newer syntax)
alias gsw='git switch'

# 26. Create and switch to new branch
alias gswc='git switch -c'

# 27. Merge branch
alias gm='git merge'

# 28. Merge with no fast-forward
alias gmnf='git merge --no-ff'

# 29. Abort merge
alias gma='git merge --abort'

# 30. Show merged branches
alias gbm='git branch --merged'

# ============================================================================
# LOGGING AND HISTORY (31-45)
# ============================================================================

# 31. Pretty log
alias glog='git log --oneline --decorate --graph'

# 32. Pretty log with all branches
alias gloga='git log --oneline --decorate --graph --all'

# 33. Log with dates
alias glogd='git log --pretty=format:"%h %ad %s" --date=short'

# 34. Log with stats
alias glogs='git log --stat'

# 35. Log with patch
alias glogp='git log -p'

# 36. Show last commit
alias glast='git log -1 HEAD'

# 37. Show who changed what
alias gblame='git blame'

# 38. Show changes in last commit
alias gshow='git show'

# 39. Show file at specific commit
alias gshowf='git show'

# 40. List commits by author
alias gauthor='git log --author'

# 41. Search commits
alias gsearch='git log --all --grep'

# 42. Show branches with last commit
alias gbv='git branch -v'

# 43. Show branches with more info
alias gbvv='git branch -vv'

# 44. Reflog
alias grl='git reflog'

# 45. Short reflog
alias grls='git reflog --pretty=short'

# ============================================================================
# DIFF AND INSPECTION (46-60)
# ============================================================================

# 46. Show diff
alias gd='git diff'

# 47. Show diff of staged files
alias gds='git diff --staged'

# 48. Show diff with stats
alias gdst='git diff --stat'

# 49. Show diff of specific file
alias gdf='git diff'

# 50. Show word diff
alias gdw='git diff --word-diff'

# 51. Show diff between branches
alias gdb='git diff'

# 52. Show files changed
alias gdfiles='git diff --name-only'

# 53. Show files changed with status
alias gdstat='git diff --name-status'

# 54. Show diff in color
alias gdc='git diff --color-words'

# 55. Show what changed in last commit
alias gdlc='git diff HEAD^ HEAD'

# 56. List tracked files
alias gls='git ls-files'

# 57. List untracked files
alias glsu='git ls-files --others'

# 58. Show file content at commit
alias gcat='git show'

# 59. Show contributors
alias gcontrib='git shortlog -sn'

# 60. Show file history
alias gfh='git log --follow -p --'

# ============================================================================
# STASHING (61-70)
# ============================================================================

# 61. Stash changes
alias gst='git stash'

# 62. Stash with message
alias gstm='git stash save'

# 63. Stash including untracked
alias gstu='git stash -u'

# 64. Stash all (including ignored)
alias gsta='git stash -a'

# 65. List stashes
alias gstl='git stash list'

# 66. Show stash content
alias gsts='git stash show -p'

# 67. Apply last stash
alias gstap='git stash apply'

# 68. Pop last stash
alias gstpo='git stash pop'

# 69. Drop stash
alias gstd='git stash drop'

# 70. Clear all stashes
alias gstc='git stash clear'

# ============================================================================
# REMOTE OPERATIONS (71-80)
# ============================================================================

# 71. Show remotes
alias gr='git remote'

# 72. Show remotes with URLs
alias grv='git remote -v'

# 73. Add remote
alias gra='git remote add'

# 74. Remove remote
alias grr='git remote remove'

# 75. Rename remote
alias grrm='git remote rename'

# 76. Fetch from origin
alias gf='git fetch'

# 77. Fetch all remotes
alias gfa='git fetch --all'

# 78. Fetch with prune
alias gfp='git fetch --prune'

# 79. Clone repository
alias gcl='git clone'

# 80. Clone with depth
alias gcld='git clone --depth 1'

# ============================================================================
# RESET AND CLEAN (81-90)
# ============================================================================

# 81. Reset to last commit (soft)
alias grss='git reset --soft HEAD~1'

# 82. Reset to last commit (mixed)
alias grsm='git reset HEAD~1'

# 83. Reset to last commit (hard)
alias grsh='git reset --hard HEAD~1'

# 84. Reset to origin
alias grso='git reset --hard origin/$(git branch --show-current)'

# 85. Unstage all files
alias gus='git reset HEAD'

# 86. Unstage specific file
alias gusf='git reset HEAD --'

# 87. Clean untracked files (dry run)
alias gcn='git clean -n'

# 88. Clean untracked files
alias gcf='git clean -f'

# 89. Clean untracked files and directories
alias gcfd='git clean -fd'

# 90. Discard changes in file
alias gdis='git checkout --'

# ============================================================================
# ADVANCED OPERATIONS (91-100)
# ============================================================================

# 91. Cherry-pick commit
alias gcp='git cherry-pick'

# 92. Cherry-pick and continue
alias gcpc='git cherry-pick --continue'

# 93. Cherry-pick abort
alias gcpa='git cherry-pick --abort'

# 94. Rebase interactive
alias grbi='git rebase -i'

# 95. Rebase continue
alias grbc='git rebase --continue'

# 96. Rebase abort
alias grba='git rebase --abort'

# 97. Rebase skip
alias grbs='git rebase --skip'

# 98. Show tags
alias gt='git tag'

# 99. Create tag
alias gta='git tag -a'

# 100. Push tags
alias gpt='git push --tags'

# ============================================================================
# FUNCTIONS - Complex Operations
# ============================================================================

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

# Update all branches
gupdateall() {
    git fetch --all
    git pull --all
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
    git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | awk '/^blob/ {print substr($0,6)}' | sort --numeric-sort --key=2 | tail -${1:-10}
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
    find . -name "node_modules" -type d -prune -exec rm -rf {} \;
    echo "Removed all node_modules directories"
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
