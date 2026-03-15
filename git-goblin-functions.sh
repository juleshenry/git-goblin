#!/bin/bash
# git-goblin-functions.sh
# Modern bash functions for git-goblin utilities
# Usage: source /path/to/git-goblin/git-goblin-functions.sh

# ============================================================================
# COLORS & FORMATTING
# ============================================================================

_gg_red='\033[0;31m'
_gg_green='\033[0;32m'
_gg_yellow='\033[0;33m'
_gg_blue='\033[0;34m'
_gg_magenta='\033[0;35m'
_gg_cyan='\033[0;36m'
_gg_bold='\033[1m'
_gg_dim='\033[2m'
_gg_reset='\033[0m'

_gg_ok()   { echo -e "${_gg_green}${_gg_bold}[ok]${_gg_reset} $*"; }
_gg_info() { echo -e "${_gg_cyan}[..]${_gg_reset} $*"; }
_gg_warn() { echo -e "${_gg_yellow}[!!]${_gg_reset} $*"; }
_gg_err()  { echo -e "${_gg_red}[ERR]${_gg_reset} $*" >&2; }

# ============================================================================
# GIT WORKFLOW FUNCTIONS
# ============================================================================

# gg: git add, commit, and push in one command
# Usage: gg "commit message"
gg() {
    if [ -z "$1" ]; then
        _gg_err "Usage: gg \"commit message\""
        return 1
    fi
    _gg_info "Staging all changes..."
    git add . || { _gg_err "git add failed"; return 1; }
    _gg_info "Committing: $1"
    git commit -m "$1" || { _gg_err "git commit failed"; return 1; }
    _gg_info "Pushing to remote..."
    git push || { _gg_err "git push failed"; return 1; }
    _gg_ok "Done -- add, commit, push complete."
}

# gclo: git clone shortcut
# Usage: gclo username/repo
gclo() {
    if [ -z "$1" ]; then
        _gg_err "Usage: gclo username/repo"
        return 1
    fi
    _gg_info "Cloning github.com/$1 ..."
    git clone "https://github.com/$1"
}

# jclo: git clone for juleshenry repositories
# Usage: jclo reponame
jclo() {
    if [ -z "$1" ]; then
        _gg_err "Usage: jclo reponame"
        return 1
    fi
    local j=juleshenry
    _gg_info "Cloning github.com/$j/$1 ..."
    git clone "https://github.com/$j/$1"
}

# presto: Delete all git history - use with extreme caution!
presto() {
    _gg_warn "This will ${_gg_bold}DESTROY ALL GIT HISTORY${_gg_reset} for this repo."
    read -p "Type 'yes' to confirm: " confirm
    if [ "$confirm" != "yes" ]; then
        _gg_info "Aborted."
        return 1
    fi
    git checkout --orphan annie
    git add -A
    git commit -am 'cm'
    git branch -D main
    git branch -m main
    git push -f origin main
    _gg_ok "History wiped. Fresh start on main."
}

# gwip: quick work-in-progress commit (no push)
gwip() {
    git add .
    git commit -m "wip: $(date '+%H:%M:%S')"
    _gg_ok "WIP commit saved."
}

# gunwip: undo last wip commit, keep changes staged
gunwip() {
    local last_msg
    last_msg=$(git log -1 --pretty=%s 2>/dev/null)
    if [[ "$last_msg" == wip:* ]]; then
        git reset --soft HEAD~1
        _gg_ok "Unwound WIP commit. Changes are staged."
    else
        _gg_warn "Last commit doesn't look like a WIP: $last_msg"
        return 1
    fi
}

# gpristine: reset repo to match remote exactly
gpristine() {
    _gg_warn "Discarding ALL local changes to match remote."
    read -p "Continue? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git reset --hard origin/"$(git branch --show-current)"
        git clean -fd
        _gg_ok "Repo is pristine."
    else
        _gg_info "Aborted."
    fi
}

# gtag: create and push a tag in one step
# Usage: gtag v1.0.0 "Release message"
gtag() {
    if [ -z "$1" ]; then
        _gg_err "Usage: gtag <tag> [message]"
        return 1
    fi
    local msg="${2:-$1}"
    git tag -a "$1" -m "$msg" && git push origin "$1"
    _gg_ok "Tag $1 created and pushed."
}

# gpr: create a pull request via gh CLI
# Usage: gpr "PR title"
gpr() {
    if ! command -v gh &>/dev/null; then
        _gg_err "GitHub CLI (gh) is not installed."
        return 1
    fi
    if [ -z "$1" ]; then
        _gg_err "Usage: gpr \"PR title\""
        return 1
    fi
    git push -u origin "$(git branch --show-current)" 2>/dev/null
    gh pr create --title "$1" --fill
    _gg_ok "PR created."
}

# gdiff-fancy: show a pretty diff summary
gdiff-fancy() {
    echo -e "${_gg_bold}--- Changes Summary ---${_gg_reset}"
    echo -e "${_gg_green}$(git diff --stat)${_gg_reset}"
    echo ""
    echo -e "${_gg_dim}$(git diff --shortstat)${_gg_reset}"
}

# ============================================================================
# SHELL HISTORY FUNCTIONS
# ============================================================================

# h: grep shell history
# Usage: h searchterm
h() {
    if [ -z "$1" ]; then
        _gg_err "Usage: h <searchterm>"
        return 1
    fi
    history 1 | grep --color=auto "$1"
}

# hl: history-grep "I'm feeling lucky" prompt
# Usage: hl searchterm
hl() {
    if [ -z "$1" ]; then
        _gg_err "Usage: hl <searchterm>"
        return 1
    fi
    local result
    result=$(history 1 | grep "$1" | tail -n 2 | head -n 1)
    if [ -z "$result" ]; then
        _gg_warn "No matches for '$1'"
        return 1
    fi
    echo -e "${_gg_cyan}Penultimate match:${_gg_reset} $result"
    read -p "Press Enter to execute, or Ctrl+C to cancel..."
    eval "$result"
}

# ============================================================================
# FILE MANAGEMENT FUNCTIONS
# ============================================================================

# dst: Remove all .DS_Store files recursively
dst() {
    local count
    count=$(find . -type f -name '.DS_Store' 2>/dev/null | wc -l | tr -d ' ')
    find . -type f -name '.DS_Store' -exec rm {} +
    _gg_ok "Removed $count .DS_Store file(s)."
}

# dust-kash: Remove all .kash cache files recursively
dust-kash() {
    local count
    count=$(find . -type f -name '*.kash' 2>/dev/null | wc -l | tr -d ' ')
    find . -type f -name '*.kash' -exec rm {} +
    _gg_ok "Removed $count .kash file(s)."
}

# cruft: Find files larger than 1G (root)
cruft() {
    find / -type f -size +1G -exec du -h {} + 2>/dev/null | sort -rh
}

# date-file-maker: Create a UTC timestamped text file
date-file-maker() {
    local fname
    fname="$(date -u '+%m-%d-%y-%H:%M:%S').txt"
    touch "$fname"
    _gg_ok "Created $fname"
}

# swap: Swap the names of two files
# Usage: swap file1 file2
swap() {
    if [ -z "$2" ]; then
        _gg_err "Usage: swap <file1> <file2>"
        return 1
    fi
    if [ ! -e "$1" ]; then _gg_err "File not found: $1"; return 1; fi
    if [ ! -e "$2" ]; then _gg_err "File not found: $2"; return 1; fi
    local tmp_name
    tmp_name=$(TMPDIR=$(dirname -- "$1") mktemp)
    mv -f -- "$1" "$tmp_name"
    mv -f -- "$2" "$1"
    mv -f -- "$tmp_name" "$2"
    _gg_ok "Swapped $1 <-> $2"
}

# mkcd: mkdir and cd into it
mkcd() {
    if [ -z "$1" ]; then
        _gg_err "Usage: mkcd <dirname>"
        return 1
    fi
    mkdir -p "$1" && cd "$1" || return 1
    _gg_ok "Created and entered $1"
}

# extract: universal archive extractor
extract() {
    if [ -z "$1" ]; then
        _gg_err "Usage: extract <archive>"
        return 1
    fi
    if [ ! -f "$1" ]; then
        _gg_err "'$1' is not a valid file."
        return 1
    fi
    case "$1" in
        *.tar.bz2) tar xjf "$1"   ;;
        *.tar.gz)  tar xzf "$1"   ;;
        *.tar.xz)  tar xJf "$1"   ;;
        *.bz2)     bunzip2 "$1"   ;;
        *.gz)      gunzip "$1"    ;;
        *.tar)     tar xf "$1"    ;;
        *.tbz2)    tar xjf "$1"   ;;
        *.tgz)     tar xzf "$1"   ;;
        *.zip)     unzip "$1"     ;;
        *.7z)      7z x "$1"      ;;
        *.rar)     unrar x "$1"   ;;
        *) _gg_err "Cannot extract '$1': unknown format"; return 1 ;;
    esac
    _gg_ok "Extracted $1"
}

# tre: tree with sensible defaults (ignore .git, node_modules)
tre() {
    if command -v tree &>/dev/null; then
        tree -I '.git|node_modules|__pycache__|.venv|venv' -a --dirsfirst "${@:-.}"
    else
        _gg_warn "'tree' not installed. Falling back to find."
        find "${@:-.}" -not -path '*/.git/*' -not -path '*/node_modules/*' | head -100
    fi
}

# ports: show what's listening on which ports
ports() {
    if command -v lsof &>/dev/null; then
        lsof -iTCP -sTCP:LISTEN -P -n
    elif command -v ss &>/dev/null; then
        ss -tlnp
    else
        _gg_err "Neither lsof nor ss available."
        return 1
    fi
}

# sizeof: human-readable size of a file or directory
sizeof() {
    if [ -z "$1" ]; then
        _gg_err "Usage: sizeof <path>"
        return 1
    fi
    du -sh "$1" 2>/dev/null | cut -f1
}

# ============================================================================
# DEVELOPMENT FUNCTIONS
# ============================================================================

# blk: Run Python Black formatter on a file
# Usage: blk filename.py
blk() {
    if [ -z "$1" ]; then
        _gg_err "Usage: blk <filename.py>"
        return 1
    fi
    python3 -m black "$1"
}

# serve: quick HTTP server in current directory
serve() {
    local port="${1:-8000}"
    _gg_info "Serving on http://localhost:$port ..."
    python3 -m http.server "$port"
}

# jql: pipe JSON through jq with color, into less
jql() {
    if ! command -v jq &>/dev/null; then
        _gg_err "jq is not installed."
        return 1
    fi
    jq -C '.' "$@" | less -R
}

# ============================================================================
# G -- The Git-Goblin Shell: Hot-Doc Autofiller
# ============================================================================
#
# G is the git-goblin command brain. Three modes:
#
#   G                   -- launch interactive autocomplete (fuzzy-find all cmds)
#   G 'git status'      -- best-guess which goblin shortcut matches, show blurb
#   G -a 'cmd' 'desc'   -- add a new custom shortcut to the registry on the fly
#
# The registry persists via a file at ~/.git-goblin-custom so user additions
# survive across sessions.

# --- Where user custom commands are saved ---
_GG_CUSTOM_FILE="${HOME}/.git-goblin-custom"

# --- Built-in registry: shortcut -> "underlying_command ||| description" ---
declare -A _GG_REGISTRY

_gg_init_registry() {
    _GG_REGISTRY=(
        # ── Git Workflow ──
        ["gg"]="git add . && git commit -m MSG && git push ||| Add all, commit, push in one shot"
        ["gclo"]="git clone https://github.com/USER/REPO ||| Clone a GitHub repo"
        ["jclo"]="git clone https://github.com/juleshenry/REPO ||| Clone a juleshenry repo"
        ["presto"]="git checkout --orphan && force-push ||| DESTRUCTIVE: wipe all git history"
        ["gwip"]="git add . && git commit -m 'wip: TIME' ||| Quick work-in-progress commit (no push)"
        ["gunwip"]="git reset --soft HEAD~1 ||| Undo last WIP commit, keep changes staged"
        ["gpristine"]="git reset --hard origin/BRANCH && git clean -fd ||| Hard-reset to match remote exactly"
        ["gtag"]="git tag -a TAG -m MSG && git push origin TAG ||| Create and push a git tag"
        ["gpr"]="gh pr create --title TITLE --fill ||| Create a GitHub PR via gh CLI"
        ["gdiff-fancy"]="git diff --stat + git diff --shortstat ||| Pretty diff summary with stats"
        ["gacp"]="git add . && git commit -m MSG && git push ||| Add, commit, push (same as gg)"
        ["ginit"]="git init && git add . && git commit -m 'Initial commit' ||| Init repo with first commit"
        ["ghcl"]="git clone https://github.com/USER/REPO ||| Clone from GitHub"
        ["gbc"]="git checkout -b BRANCH ||| Create and switch to new branch"
        ["gbdall"]="git branch -d B && git push origin --delete B ||| Delete branch locally + remotely"
        ["gundo"]="git reset --soft HEAD~1 ||| Undo last commit, keep changes staged"
        ["gbs"]="git for-each-ref --sort=-committerdate ||| Show branches sorted by last modified"
        ["gquick"]="git add . && git commit -m 'Quick update: TIME' && git push ||| Commit+push with auto-timestamp"
        ["gchanged"]="git diff --name-only HEAD~N..HEAD ||| Show changed files in last N commits"
        ["gsearchtext"]="git log -S TEXT ||| Search for text across git history"
        ["gnew"]="git fetch origin && git checkout -b B origin/main ||| Create branch from origin/main"
        ["gupdateall"]="git fetch --all && git pull ||| Fetch all remotes and pull"
        ["greposize"]="git count-objects -vH ||| Show repo object storage size"
        ["gfilesize"]="git ls-tree -r -t -l --full-name HEAD | sort ||| List files by size in repo"
        ["glarge"]="git rev-list --objects --all | ... ||| Find N largest blobs in history"
        ["gsyncfork"]="git fetch upstream && merge upstream/main ||| Sync fork with upstream/main"
        ["gsquash"]="git reset --soft HEAD~N && git commit -m MSG ||| Squash last N commits"
        ["gstats"]="git shortlog -sn --all --no-merges ||| Commit count by author"
        ["garchive"]="git tag archive/B && delete branch ||| Archive a branch as a tag"
        ["galias"]="alias | grep '^g' ||| List all g* aliases"
        ["ginfo"]="repo name, branch, remote, last commit ||| Show repo info summary"
        ["gbackup"]="tar -czf backup.tar.gz . ||| Tar.gz backup of current repo"

        # ── Git Aliases (mega_script) ──
        ["gs"]="git status ||| Show working tree status"
        ["gss"]="git status -s ||| Short-format status"
        ["ga"]="git add . ||| Stage all changes"
        ["gaf"]="git add FILE ||| Stage a specific file"
        ["gc"]="git commit -m MSG ||| Commit with message"
        ["gca"]="git commit -a -m MSG ||| Commit all tracked files"
        ["gcam"]="git commit --amend -m MSG ||| Amend last commit message"
        ["gcan"]="git commit --amend --no-edit ||| Amend last commit, keep message"
        ["gp"]="git push ||| Push to origin"
        ["gpf"]="git push --force ||| Force push"
        ["gpfl"]="git push --force-with-lease ||| Force push (safer)"
        ["gpu"]="git push -u origin BRANCH ||| Push and set upstream"
        ["gl"]="git pull ||| Pull from origin"
        ["glr"]="git pull --rebase ||| Pull with rebase"
        ["glp"]="git pull --prune ||| Pull and prune dead refs"
        ["gb"]="git branch ||| List local branches"
        ["gba"]="git branch -a ||| List all branches (local+remote)"
        ["gbd"]="git branch -d BRANCH ||| Delete a branch"
        ["gbdf"]="git branch -D BRANCH ||| Force delete a branch"
        ["gco"]="git checkout BRANCH ||| Checkout a branch"
        ["gcob"]="git checkout -b BRANCH ||| Create + checkout new branch"
        ["gcop"]="git checkout - ||| Checkout previous branch"
        ["gcom"]="git checkout main || git checkout master ||| Checkout main/master"
        ["gsw"]="git switch BRANCH ||| Switch to branch (modern)"
        ["gswc"]="git switch -c BRANCH ||| Create + switch to new branch"
        ["gm"]="git merge BRANCH ||| Merge a branch"
        ["gmnf"]="git merge --no-ff BRANCH ||| Merge with no fast-forward"
        ["gma"]="git merge --abort ||| Abort a merge"
        ["gbm"]="git branch --merged ||| Show merged branches"
        ["glog"]="git log --oneline --decorate --graph ||| Pretty commit graph"
        ["gloga"]="git log --oneline --decorate --graph --all ||| Pretty graph, all branches"
        ["glogd"]="git log --pretty=format:'%h %ad %s' --date=short ||| Log with dates"
        ["glogs"]="git log --stat ||| Log with file stats"
        ["glogp"]="git log -p ||| Log with patches"
        ["glast"]="git log -1 HEAD ||| Show last commit"
        ["gblame"]="git blame FILE ||| Show who changed each line"
        ["gshow"]="git show ||| Show last commit details"
        ["gauthor"]="git log --author NAME ||| Filter log by author"
        ["gsearch"]="git log --all --grep TERM ||| Search commit messages"
        ["gbv"]="git branch -v ||| Branches with last commit"
        ["gbvv"]="git branch -vv ||| Branches with tracking info"
        ["grl"]="git reflog ||| Show reflog"
        ["gd"]="git diff ||| Show unstaged diff"
        ["gds"]="git diff --staged ||| Show staged diff"
        ["gdst"]="git diff --stat ||| Diff with stats"
        ["gdw"]="git diff --word-diff ||| Word-level diff"
        ["gdc"]="git diff --color-words ||| Color word diff"
        ["gdfiles"]="git diff --name-only ||| List changed filenames"
        ["gdstat"]="git diff --name-status ||| Changed files with status"
        ["gdlc"]="git diff HEAD^ HEAD ||| Diff of last commit"
        ["gls"]="git ls-files ||| List tracked files"
        ["glsu"]="git ls-files --others ||| List untracked files"
        ["gcontrib"]="git shortlog -sn ||| Show contributors"
        ["gfh"]="git log --follow -p -- FILE ||| Show full file history"
        ["gst"]="git stash ||| Stash changes"
        ["gstm"]="git stash push -m MSG ||| Stash with message"
        ["gstu"]="git stash -u ||| Stash including untracked"
        ["gsta"]="git stash -a ||| Stash all (including ignored)"
        ["gstl"]="git stash list ||| List stashes"
        ["gsts"]="git stash show -p ||| Show stash content"
        ["gstap"]="git stash apply ||| Apply last stash"
        ["gstpo"]="git stash pop ||| Pop last stash"
        ["gstd"]="git stash drop ||| Drop a stash"
        ["gstc"]="git stash clear ||| Clear all stashes"
        ["gr"]="git remote ||| Show remotes"
        ["grv"]="git remote -v ||| Show remotes with URLs"
        ["gra"]="git remote add NAME URL ||| Add a remote"
        ["grr"]="git remote remove NAME ||| Remove a remote"
        ["gf"]="git fetch ||| Fetch from origin"
        ["gfa"]="git fetch --all ||| Fetch all remotes"
        ["gfp"]="git fetch --prune ||| Fetch with prune"
        ["gcl"]="git clone URL ||| Clone a repository"
        ["gcld"]="git clone --depth 1 URL ||| Shallow clone"
        ["grss"]="git reset --soft HEAD~1 ||| Soft reset last commit"
        ["grsm"]="git reset HEAD~1 ||| Mixed reset last commit"
        ["grsh"]="git reset --hard HEAD~1 ||| Hard reset last commit"
        ["grso"]="git reset --hard origin/BRANCH ||| Reset to origin"
        ["gus"]="git reset HEAD ||| Unstage all files"
        ["gusf"]="git reset HEAD -- FILE ||| Unstage a specific file"
        ["gcn"]="git clean -n ||| Clean dry run"
        ["gcf"]="git clean -f ||| Clean untracked files"
        ["gcfd"]="git clean -fd ||| Clean untracked files + dirs"
        ["gdis"]="git checkout -- FILE ||| Discard changes in file"
        ["gcp"]="git cherry-pick HASH ||| Cherry-pick a commit"
        ["gcpc"]="git cherry-pick --continue ||| Continue cherry-pick"
        ["gcpa"]="git cherry-pick --abort ||| Abort cherry-pick"
        ["grbi"]="git rebase -i HASH ||| Interactive rebase"
        ["grbc"]="git rebase --continue ||| Continue rebase"
        ["grba"]="git rebase --abort ||| Abort rebase"
        ["grbs"]="git rebase --skip ||| Skip rebase step"
        ["gt"]="git tag ||| Show tags"
        ["gta"]="git tag -a TAG ||| Create annotated tag"
        ["gpt"]="git push --tags ||| Push all tags"

        # ── Shell / File Utilities ──
        ["h"]="history | grep TERM ||| Grep shell history"
        ["hl"]="history lucky match + exec ||| Run penultimate history match"
        ["dst"]="find . -name '.DS_Store' -exec rm ||| Remove .DS_Store files recursively"
        ["dust-kash"]="find . -name '*.kash' -exec rm ||| Remove .kash cache files recursively"
        ["date-file-maker"]="touch MM-DD-YY-HH:MM:SS.txt ||| Create a UTC-timestamped file"
        ["swap"]="mv file1 tmp && mv file2 file1 && mv tmp file2 ||| Swap names of two files"
        ["mkcd"]="mkdir -p DIR && cd DIR ||| mkdir + cd in one step"
        ["extract"]="tar/unzip/7z/etc ||| Universal archive extractor"
        ["tre"]="tree -I '.git|node_modules' ||| tree with junk dirs ignored"
        ["ports"]="lsof -iTCP -sTCP:LISTEN ||| Show listening TCP ports"
        ["sizeof"]="du -sh PATH ||| Human-readable size of file/dir"
        ["blk"]="python3 -m black FILE ||| Run Python Black formatter"
        ["serve"]="python3 -m http.server PORT ||| Quick HTTP server"
        ["jql"]="jq -C '.' FILE | less -R ||| Pretty-print JSON with less"
        ["rmdstore"]="find . -name '.DS_Store' -delete ||| Remove .DS_Store with feedback"
        ["rmnodemodules"]="find+rm node_modules ||| Interactively remove node_modules dirs"
        ["countext"]="find . -type f | sed/sort/uniq ||| Count files by extension"
        ["findlarge"]="find . -type f -size +N ||| Find files larger than N"

        # ── Docker ──
        ["dps"]="docker ps ||| List running containers"
        ["dpsa"]="docker ps -a ||| List all containers"
        ["di"]="docker images ||| List images"
        ["drm"]="docker rm ||| Remove a container"
        ["drmi"]="docker rmi ||| Remove an image"
        ["drmf"]="docker rm -f \$(docker ps -aq) ||| Force remove all containers"
        ["drmia"]="docker rmi \$(docker images -q) ||| Remove all images"
        ["dex"]="docker exec -it CONTAINER bash ||| Exec into container"
        ["dl"]="docker logs -f CONTAINER ||| Follow container logs"
        ["dstop"]="docker stop \$(docker ps -aq) ||| Stop all containers"
        ["dprune"]="docker system prune -af ||| Prune everything (containers, images, networks)"
        ["dc"]="docker compose ||| Docker Compose shortcut"
        ["dcu"]="docker compose up -d ||| Compose up (detached)"
        ["dcd"]="docker compose down ||| Compose down"
        ["dcb"]="docker compose build ||| Compose build"
        ["dcl"]="docker compose logs -f ||| Follow compose logs"
        ["dcr"]="docker compose restart ||| Restart compose services"
        ["dvls"]="docker volume ls ||| List volumes"
        ["dnls"]="docker network ls ||| List networks"
        ["dbuild"]="docker build -t NAME . ||| Build image from Dockerfile"

        # ── Kubernetes ──
        ["k"]="kubectl ||| kubectl shortcut"
        ["kgp"]="kubectl get pods ||| List pods"
        ["kgpa"]="kubectl get pods --all-namespaces ||| List all pods across namespaces"
        ["kgs"]="kubectl get svc ||| List services"
        ["kgn"]="kubectl get nodes ||| List nodes"
        ["kgd"]="kubectl get deployments ||| List deployments"
        ["kgi"]="kubectl get ingress ||| List ingresses"
        ["kgns"]="kubectl get namespaces ||| List namespaces"
        ["kga"]="kubectl get all ||| List all resources"
        ["kdp"]="kubectl describe pod POD ||| Describe a pod"
        ["kds"]="kubectl describe svc SVC ||| Describe a service"
        ["kdd"]="kubectl describe deployment DEP ||| Describe a deployment"
        ["kl"]="kubectl logs -f POD ||| Follow pod logs"
        ["klp"]="kubectl logs -f POD -p ||| Previous pod logs"
        ["kex"]="kubectl exec -it POD -- bash ||| Exec into a pod"
        ["kaf"]="kubectl apply -f FILE ||| Apply a manifest"
        ["kdf"]="kubectl delete -f FILE ||| Delete from manifest"
        ["kctx"]="kubectl config get-contexts ||| Show kube contexts"
        ["kuse"]="kubectl config use-context CTX ||| Switch kube context"
        ["kns"]="kubectl config set-context --current --namespace=NS ||| Set default namespace"
        ["kpf"]="kubectl port-forward POD LOCAL:REMOTE ||| Port-forward to a pod"
        ["kscale"]="kubectl scale deployment DEP --replicas=N ||| Scale a deployment"
        ["krollout"]="kubectl rollout status deployment DEP ||| Check rollout status"
        ["krestart"]="kubectl rollout restart deployment DEP ||| Restart a deployment"
        ["ktop"]="kubectl top pods ||| Pod resource usage"
        ["ktopn"]="kubectl top nodes ||| Node resource usage"

        # ── AWS CLI ──
        ["awsid"]="aws sts get-caller-identity ||| Show current AWS identity"
        ["awsls"]="aws s3 ls ||| List S3 buckets"
        ["awscp"]="aws s3 cp FILE s3://BUCKET/ ||| Copy file to S3"
        ["awssync"]="aws s3 sync DIR s3://BUCKET/ ||| Sync directory to S3"
        ["awsec2"]="aws ec2 describe-instances ||| List EC2 instances"
        ["awsecr"]="aws ecr get-login-password | docker login ||| ECR docker login"
        ["awslam"]="aws lambda list-functions ||| List Lambda functions"
        ["awslog"]="aws logs tail LOG_GROUP --follow ||| Tail CloudWatch logs"
        ["awseb"]="aws elasticbeanstalk describe-environments ||| List EB environments"
        ["awscf"]="aws cloudformation list-stacks ||| List CloudFormation stacks"
        ["awseks"]="aws eks list-clusters ||| List EKS clusters"
        ["awsrds"]="aws rds describe-db-instances ||| List RDS instances"
        ["awsssm"]="aws ssm start-session --target INSTANCE ||| SSM session to instance"
        ["awswho"]="aws iam get-user ||| Show current IAM user"
        ["awsregions"]="aws ec2 describe-regions --output table ||| List all AWS regions"

        # ── GCP / gcloud ──
        ["gcpid"]="gcloud config get-value project ||| Show current GCP project"
        ["gcpset"]="gcloud config set project PROJECT ||| Set GCP project"
        ["gcpls"]="gcloud compute instances list ||| List GCE instances"
        ["gcpssh"]="gcloud compute ssh INSTANCE ||| SSH into GCE instance"
        ["gcpgke"]="gcloud container clusters list ||| List GKE clusters"
        ["gcpgkecreds"]="gcloud container clusters get-credentials CLUSTER ||| Get GKE kubeconfig"
        ["gcpbq"]="bq ls ||| List BigQuery datasets"
        ["gcpgsutil"]="gsutil ls ||| List GCS buckets"
        ["gcpcp"]="gsutil cp FILE gs://BUCKET/ ||| Copy file to GCS"
        ["gcpsync"]="gsutil -m rsync -r DIR gs://BUCKET/ ||| Sync directory to GCS"
        ["gcprun"]="gcloud run services list ||| List Cloud Run services"
        ["gcpfn"]="gcloud functions list ||| List Cloud Functions"
        ["gcpsql"]="gcloud sql instances list ||| List Cloud SQL instances"
        ["gcplog"]="gcloud logging read FILTER --limit=50 ||| Read GCP logs"
        ["gcpauth"]="gcloud auth login ||| Authenticate with GCP"

        # ── Terraform ──
        ["tf"]="terraform ||| Terraform shortcut"
        ["tfi"]="terraform init ||| Initialize Terraform"
        ["tfp"]="terraform plan ||| Plan changes"
        ["tfa"]="terraform apply ||| Apply changes"
        ["tfaa"]="terraform apply -auto-approve ||| Apply without prompt"
        ["tfd"]="terraform destroy ||| Destroy infrastructure"
        ["tfs"]="terraform state list ||| List state resources"
        ["tfo"]="terraform output ||| Show outputs"
        ["tfv"]="terraform validate ||| Validate config"
        ["tff"]="terraform fmt -recursive ||| Format all .tf files"
        ["tfw"]="terraform workspace list ||| List workspaces"

        # ── Misc DevOps ──
        ["hup"]="helm upgrade --install RELEASE CHART ||| Helm upgrade/install"
        ["hls"]="helm list ||| List Helm releases"
        ["hdel"]="helm uninstall RELEASE ||| Uninstall Helm release"
        ["ans"]="ansible-playbook PLAYBOOK.yml ||| Run Ansible playbook"
        ["vup"]="vagrant up ||| Start Vagrant VM"
        ["vsh"]="vagrant ssh ||| SSH into Vagrant VM"
        ["vhalt"]="vagrant halt ||| Stop Vagrant VM"

        # ── npm / yarn / pnpm ──
        ["ni"]="npm install ||| npm install"
        ["nid"]="npm install --save-dev ||| npm install as dev dependency"
        ["nig"]="npm install -g ||| npm install globally"
        ["nrd"]="npm run dev ||| npm run dev server"
        ["nrb"]="npm run build ||| npm run build"
        ["nrs"]="npm run start ||| npm run start"
        ["nrt"]="npm run test ||| npm run test"
        ["nrl"]="npm run lint ||| npm run lint"
        ["nls"]="npm list --depth=0 ||| List top-level npm packages"
        ["nout"]="npm outdated ||| Show outdated npm packages"
        ["nup"]="npm update ||| Update npm packages"
        ["naf"]="npm audit fix ||| Fix npm audit vulnerabilities"
        ["ncc"]="npm cache clean --force ||| Clear npm cache"
        ["ninit"]="npm init -y ||| Initialize new npm project"
        ["nx"]="npx ||| npx shortcut"
        ["yi"]="yarn install ||| Yarn install dependencies"
        ["ya"]="yarn add PACKAGE ||| Yarn add package"
        ["yad"]="yarn add --dev PACKAGE ||| Yarn add dev dependency"
        ["yrd"]="yarn dev ||| Yarn dev server"
        ["yrb"]="yarn build ||| Yarn build"
        ["yrs"]="yarn start ||| Yarn start"
        ["yrt"]="yarn test ||| Yarn test"
        ["yga"]="yarn global add PACKAGE ||| Yarn global install"
        ["pi"]="pnpm install ||| pnpm install dependencies"
        ["pad"]="pnpm add PACKAGE ||| pnpm add package"
        ["padd"]="pnpm add -D PACKAGE ||| pnpm add dev dependency"
        ["prd"]="pnpm dev ||| pnpm dev server"
        ["prb"]="pnpm build ||| pnpm build"
        ["prs"]="pnpm start ||| pnpm start"
        ["prt"]="pnpm test ||| pnpm test"

        # ── Python / pip / venv ──
        ["py"]="python3 ||| Python3 shortcut"
        ["py2"]="python2 ||| Python2 shortcut"
        ["pip3i"]="pip3 install PACKAGE ||| pip install a package"
        ["pipr"]="pip3 install -r requirements.txt ||| pip install from requirements"
        ["pipf"]="pip3 freeze > requirements.txt ||| Freeze pip deps to requirements"
        ["pipl"]="pip3 list ||| List installed pip packages"
        ["pipo"]="pip3 list --outdated ||| List outdated pip packages"
        ["pipu"]="pip3 install --upgrade PACKAGE ||| Upgrade a pip package"
        ["pipun"]="pip3 uninstall PACKAGE ||| Uninstall a pip package"
        ["venv"]="python3 -m venv venv ||| Create a virtual environment"
        ["va"]="source venv/bin/activate ||| Activate venv"
        ["vd"]="deactivate ||| Deactivate venv"
        ["pt"]="pytest ||| Run pytest"
        ["ptv"]="pytest -v ||| Run pytest verbose"
        ["ptc"]="pytest --cov ||| Run pytest with coverage"
        ["pym"]="python3 -m MODULE ||| Run Python module"
        ["ipy"]="ipython ||| Launch IPython"
        ["jnb"]="jupyter notebook ||| Launch Jupyter Notebook"
        ["jlab"]="jupyter lab ||| Launch Jupyter Lab"
        ["pide"]="pip3 install -e . ||| pip install in editable mode"

        # ── Systemd / Services ──
        ["scs"]="sudo systemctl status SERVICE ||| Show service status"
        ["scstart"]="sudo systemctl start SERVICE ||| Start a service"
        ["scstop"]="sudo systemctl stop SERVICE ||| Stop a service"
        ["screstart"]="sudo systemctl restart SERVICE ||| Restart a service"
        ["scenable"]="sudo systemctl enable SERVICE ||| Enable service at boot"
        ["scdisable"]="sudo systemctl disable SERVICE ||| Disable service at boot"
        ["screload"]="sudo systemctl reload SERVICE ||| Reload service config"
        ["scdaemon"]="sudo systemctl daemon-reload ||| Reload systemd daemon"
        ["jctl"]="sudo journalctl -f ||| Follow system journal"
        ["jctlu"]="sudo journalctl -u SERVICE ||| Journal for a specific unit"
        ["jctlt"]="sudo journalctl --since today ||| Journal since today"
        ["scls"]="systemctl list-units --type=service ||| List active services"
        ["scfail"]="systemctl --failed ||| List failed services"
        ["scactive"]="systemctl is-active SERVICE ||| Check if service is active"
        ["scenabled"]="systemctl is-enabled SERVICE ||| Check if service is enabled"

        # ── Networking ──
        ["curlt"]="curl with timing breakdown ||| curl with DNS/connect/TLS timing"
        ["curlh"]="curl -I URL ||| Show HTTP response headers"
        ["curlj"]="curl -X POST -H JSON -d DATA URL ||| curl POST with JSON body"
        ["wgetm"]="wget --mirror URL ||| Mirror/download entire site"
        ["myip"]="curl ifconfig.me ||| Show public IP address"
        ["localip"]="ipconfig getifaddr en0 ||| Show local IP address"
        ["ping5"]="ping -c 5 HOST ||| Ping with 5 packets"
        ["digs"]="dig +short DOMAIN ||| Quick DNS lookup"
        ["digr"]="dig -x IP ||| Reverse DNS lookup"
        ["nsl"]="nslookup DOMAIN ||| nslookup shortcut"
        ["trace"]="traceroute HOST ||| Traceroute to host"
        ["nstat"]="netstat -tlnp ||| Show listening ports (netstat)"
        ["ssl"]="ss -tlnp ||| Show listening ports (ss)"
        ["conns"]="ss -s ||| Show connection summary"
        ["portcheck"]="nc -zv HOST PORT ||| Check if a port is open"
        ["speedtest"]="speedtest-cli via python ||| Internet speed test"
        ["ifls"]="ifconfig / ip addr show ||| List network interfaces"
        ["headers"]="curl -sI URL ||| Show HTTP headers for URL"
        ["dlf"]="curl -L -O --progress-bar URL ||| Download file with progress"

        # ── Redis ──
        ["rd"]="redis-cli ||| Redis CLI"
        ["rdping"]="redis-cli ping ||| Ping Redis server"
        ["rdinfo"]="redis-cli info ||| Redis server info"
        ["rdmon"]="redis-cli monitor ||| Monitor Redis commands in real-time"
        ["rdkeys"]="redis-cli keys '*' ||| List all Redis keys"
        ["rdget"]="redis-cli get KEY ||| Get a Redis key value"
        ["rdset"]="redis-cli set KEY VAL ||| Set a Redis key"
        ["rddel"]="redis-cli del KEY ||| Delete a Redis key"
        ["rdflush"]="redis-cli flushdb ||| Flush current Redis DB"
        ["rdflushall"]="redis-cli flushall ||| Flush all Redis DBs"
        ["rdsize"]="redis-cli dbsize ||| Show Redis DB key count"
        ["rdshut"]="redis-cli shutdown ||| Shutdown Redis server"

        # ── PostgreSQL ──
        ["pg"]="psql ||| PostgreSQL CLI"
        ["pgsu"]="sudo -u postgres psql ||| psql as postgres superuser"
        ["pgls"]="psql -l ||| List PostgreSQL databases"
        ["pgdb"]="psql -d DB [-U user] ||| Connect to a database"
        ["pgdump"]="pg_dump DATABASE ||| Dump a database"
        ["pgrestore"]="pg_restore FILE ||| Restore a database dump"
        ["pgcreate"]="createdb DATABASE ||| Create a database"
        ["pgdrop"]="dropdb DATABASE ||| Drop a database"
        ["pgroles"]="psql -c '\\du' ||| List PostgreSQL roles"
        ["pgconn"]="SELECT from pg_stat_activity ||| Show active connections"
        ["pgsize"]="SELECT relname, pg_size_pretty(...) ||| Show table sizes"
        ["pgrunning"]="SELECT from pg_stat_activity WHERE active ||| Show running queries"
        ["pgvacuum"]="VACUUM FULL ||| Run full vacuum"
        ["pgstatus"]="systemctl status postgresql ||| PostgreSQL service status"
        ["pgver"]="psql --version ||| PostgreSQL version"

        # ── Nginx ──
        ["ngt"]="sudo nginx -t ||| Test nginx config"
        ["ngr"]="sudo nginx -s reload ||| Reload nginx"
        ["ngstart"]="sudo systemctl start nginx ||| Start nginx"
        ["ngstop"]="sudo systemctl stop nginx ||| Stop nginx"
        ["ngrestart"]="sudo systemctl restart nginx ||| Restart nginx"
        ["ngstatus"]="sudo systemctl status nginx ||| Nginx service status"
        ["ngedit"]="sudo vi /etc/nginx/nginx.conf ||| Edit nginx config"
        ["ngacc"]="sudo tail -f /var/log/nginx/access.log ||| Tail nginx access log"
        ["ngerr"]="sudo tail -f /var/log/nginx/error.log ||| Tail nginx error log"
        ["ngsites"]="ls /etc/nginx/sites-enabled/ ||| List nginx sites-enabled"
        ["ngconf"]="sudo nginx -T ||| Dump full nginx config"

        # ── Misc CLI Tools ──
        ["duh"]="du -sh * | sort -rh ||| Disk usage summary (sorted)"
        ["dfh"]="df -h ||| Disk free (human-readable)"
        ["fmem"]="free -h ||| Free memory"
        ["cpuinfo"]="lscpu ||| CPU info"
        ["w2"]="watch -n 2 CMD ||| Watch a command every 2 seconds"
        ["lsofp"]="lsof -c PROCESS ||| List open files by process"
        ["killname"]="pkill -f NAME ||| Kill process by name"
        ["hist"]="history | tail -50 ||| Last 50 history entries"
        ["cl"]="clear ||| Clear terminal"
        ["reload"]="exec \$SHELL -l ||| Reload shell config"
        ["erc"]="\${EDITOR:-vi} ~/.<shell>rc ||| Edit shell RC file"
        ["path"]="echo \$PATH | tr : newline ||| Show PATH (one per line)"
        ["cx"]="chmod +x FILE ||| Make file executable"
        ["epoch"]="date +%s ||| Print Unix timestamp"
        ["isodate"]="date -u +%Y-%m-%dT%H:%M:%SZ ||| Print ISO 8601 timestamp"
        ["uuid"]="python3 uuid4 ||| Generate a UUID"
        ["b64e"]="base64 FILE ||| Base64 encode"
        ["b64d"]="base64 --decode ||| Base64 decode"
        ["sha256"]="shasum -a 256 FILE ||| SHA256 hash of file"
        ["md5sum"]="md5 FILE ||| MD5 hash of file"

        # ── Cybersecurity / Network Recon ──
        ["tn"]="telnet HOST ||| Telnet to a host"
        ["tnp"]="telnet HOST PORT ||| Telnet to host:port"
        ["nsa"]="netstat -an ||| Netstat all connections"
        ["nstcp"]="netstat -tlnp ||| Netstat listening TCP ports"
        ["nsudp"]="netstat -ulnp ||| Netstat listening UDP ports"
        ["nsproc"]="netstat -tulnp ||| Netstat with process info"
        ["nsest"]="netstat -an | grep ESTABLISHED ||| Netstat established connections"
        ["nquick"]="nmap -F HOST ||| Nmap quick scan (top 100 ports)"
        ["nfull"]="nmap -p- HOST ||| Nmap full TCP port scan"
        ["nsvc"]="nmap -sV HOST ||| Nmap service version detection"
        ["nos"]="sudo nmap -O HOST ||| Nmap OS detection"
        ["nagg"]="sudo nmap -A HOST ||| Nmap aggressive scan (OS+ver+scripts)"
        ["nsyn"]="sudo nmap -sS HOST ||| Nmap stealth SYN scan"
        ["nudp"]="sudo nmap -sU HOST ||| Nmap UDP scan"
        ["nsweep"]="nmap -sn SUBNET ||| Nmap ping sweep (discover hosts)"
        ["nvuln"]="nmap --script vuln HOST ||| Nmap vulnerability scan"
        ["nports"]="nmap -p PORTS HOST ||| Nmap scan specific ports"
        ["nscript"]="nmap -sC HOST ||| Nmap scan with default scripts"
        ["nmapxml"]="nmap -oX output.xml HOST ||| Nmap XML output for parsing"
        ["ncl"]="nc -lvp PORT ||| Netcat listen on port"
        ["ncs"]="nc HOST PORT ||| Netcat connect to host:port"
        ["ncscan"]="nc -zv HOST START-END ||| Port scan with netcat"
        ["sslcheck"]="openssl s_client + x509 DOMAIN ||| Check SSL certificate info"
        ["sslchain"]="openssl s_client -showcerts DOMAIN ||| Show full SSL cert chain"
        ["sslciphers"]="nmap ssl-enum-ciphers -p 443 DOMAIN ||| Enumerate SSL ciphers"
        ["bannergrab"]="nc -w 3 HOST PORT ||| Banner grab via netcat"
        ["myports"]="lsof -i -P -n | grep LISTEN ||| Show open ports on this host"
        ["arptable"]="arp -a ||| Show ARP table"
        ["routes"]="netstat -rn / ip route show ||| Show routing table"
        ["fwrules"]="sudo iptables -L / pfctl -sr ||| Show firewall rules"
        ["sniff"]="sudo tcpdump -i any -nn ||| Packet sniffing (tcpdump)"
        ["tcapt"]="sudo tcpdump -w capture.pcap ||| Capture packets to file"
        ["tcport"]="sudo tcpdump port PORT ||| tcpdump filter by port"
        ["tchost"]="sudo tcpdump host HOST ||| tcpdump filter by host"
        ["secheaders"]="curl -sI URL | grep security headers ||| Check HTTP security headers"
        ["hashpw"]="echo -n PW | openssl dgst -sha512 ||| Hash a password (SHA-512)"
        ["genpw"]="tr -dc A-Za-z0-9... < /dev/urandom ||| Generate random password"
        ["worldwrite"]="find / -perm -0002 ||| Find world-writable files"
        ["findsuid"]="find / -perm -4000 ||| Find SUID binaries"
        ["whoson"]="who -a / w ||| Show all logged-in users"

        # ── Meta ──
        ["G"]="G [cmd] or G -a 'cmd' 'desc' ||| Git-Goblin hot-doc shell"
        ["gg-help"]="print reference table ||| Full command reference"
    )

    # Load user custom commands from file
    if [ -f "$_GG_CUSTOM_FILE" ]; then
        while IFS='|||' read -r key cmd desc; do
            key=$(echo "$key" | xargs)
            cmd=$(echo "$cmd" | xargs)
            desc=$(echo "$desc" | xargs)
            if [ -n "$key" ]; then
                _GG_REGISTRY["$key"]="${cmd} ||| ${desc}"
            fi
        done < "$_GG_CUSTOM_FILE"
    fi
}

# Init on source
_gg_init_registry

# ── Parse registry entry into command + description ──
_gg_parse_entry() {
    local entry="$1"
    _gg_entry_cmd="${entry%% ||| *}"
    _gg_entry_desc="${entry##* ||| }"
    # If no separator found, whole thing is description
    if [[ "$_gg_entry_cmd" == "$entry" ]]; then
        _gg_entry_cmd=""
        _gg_entry_desc="$entry"
    fi
}

# ── gg-help: print formatted reference table ──
gg-help() {
    local section="$1"
    echo -e "${_gg_bold}${_gg_magenta}  git-goblin command reference${_gg_reset}"
    echo -e "${_gg_dim}  ────────────────────────────────────────────────────────────────${_gg_reset}"
    local key
    for key in $(echo "${!_GG_REGISTRY[@]}" | tr ' ' '\n' | sort); do
        _gg_parse_entry "${_GG_REGISTRY[$key]}"
        # If filtering by section keyword
        if [ -n "$section" ]; then
            local lkey="${key,,}" lsec="${section,,}" ldesc="${_gg_entry_desc,,}" lcmd="${_gg_entry_cmd,,}"
            if [[ "$lkey" != *"$lsec"* && "$ldesc" != *"$lsec"* && "$lcmd" != *"$lsec"* ]]; then
                continue
            fi
        fi
        printf "  ${_gg_green}%-18s${_gg_reset} ${_gg_dim}%-45s${_gg_reset} %s\n" "$key" "$_gg_entry_cmd" "$_gg_entry_desc"
    done
    echo ""
    echo -e "  ${_gg_dim}Tip: ${_gg_cyan}G 'some command'${_gg_dim} to find the best shortcut${_gg_reset}"
    echo -e "  ${_gg_dim}Tip: ${_gg_cyan}G -a 'mycmd' 'what it does'${_gg_dim} to add your own${_gg_reset}"
    echo -e "  ${_gg_dim}Tip: ${_gg_cyan}gg-help docker${_gg_dim} to filter by section${_gg_reset}"
}

# ============================================================================
# G -- The main command
# ============================================================================
#
#   G                     -- interactive autocomplete (all commands)
#   G 'git status'        -- best-guess the closest shortcut for that command
#   G -a 'mycmd' 'desc'   -- add a new shortcut to the registry (persists)
#

G() {
    # ── G -a: add a custom command ──
    if [[ "$1" == "-a" ]]; then
        shift
        local new_alias="$1"
        shift
        local new_desc="$*"
        if [ -z "$new_alias" ] || [ -z "$new_desc" ]; then
            _gg_err "Usage: G -a 'command_or_alias' 'description of what it does'"
            _gg_info "Example: G -a 'docker stats' 'Live container resource usage'"
            return 1
        fi
        # Add to live registry
        _GG_REGISTRY["$new_alias"]="$new_alias ||| $new_desc"
        # Persist to file
        echo "${new_alias}|||${new_alias}|||${new_desc}" >> "$_GG_CUSTOM_FILE"
        _gg_ok "Added: ${_gg_bold}${new_alias}${_gg_reset} -- ${new_desc}"
        _gg_info "Saved to $_GG_CUSTOM_FILE (persists across sessions)."
        return 0
    fi

    # ── G 'some command': best-guess mode ──
    if [ -n "$1" ]; then
        local input="$*"
        local input_lower="${input,,}"

        # Score each registry entry by word overlap with the input
        local best_key="" best_score=0 best_cmd="" best_desc=""
        local key

        for key in "${!_GG_REGISTRY[@]}"; do
            _gg_parse_entry "${_GG_REGISTRY[$key]}"
            local cmd_lower="${_gg_entry_cmd,,}"
            local desc_lower="${_gg_entry_desc,,}"
            local key_lower="${key,,}"
            local score=0

            # Exact command match = highest priority
            if [[ "$cmd_lower" == "$input_lower" ]]; then
                score=1000
            fi

            # Input is a substring of the command
            if [[ "$cmd_lower" == *"$input_lower"* ]]; then
                (( score += 500 ))
            fi

            # Command is a substring of input
            if [[ "$input_lower" == *"$cmd_lower"* && -n "$cmd_lower" ]]; then
                (( score += 400 ))
            fi

            # Key matches input exactly
            if [[ "$key_lower" == "$input_lower" ]]; then
                (( score += 900 ))
            fi

            # Word-level overlap scoring
            local word
            for word in $input_lower; do
                if [[ "$cmd_lower" == *"$word"* ]]; then
                    (( score += 50 ))
                fi
                if [[ "$desc_lower" == *"$word"* ]]; then
                    (( score += 30 ))
                fi
                if [[ "$key_lower" == *"$word"* ]]; then
                    (( score += 40 ))
                fi
            done

            if (( score > best_score )); then
                best_score=$score
                best_key="$key"
                best_cmd="$_gg_entry_cmd"
                best_desc="$_gg_entry_desc"
            fi
        done

        if (( best_score == 0 )); then
            _gg_warn "No match found for: ${input}"
            _gg_info "Try ${_gg_cyan}G${_gg_reset} (no args) for interactive search, or ${_gg_cyan}G -a${_gg_reset} to add it."
            return 1
        fi

        # Collect runners-up (top 5)
        echo ""
        echo -e "  ${_gg_bold}${_gg_magenta}G${_gg_reset} ${_gg_dim}best guess for${_gg_reset} ${_gg_cyan}'${input}'${_gg_reset}"
        echo -e "  ${_gg_dim}────────────────────────────────────────────${_gg_reset}"
        echo ""
        echo -e "  ${_gg_green}${_gg_bold}${best_key}${_gg_reset}"
        echo -e "  ${_gg_dim}runs:${_gg_reset}  ${best_cmd}"
        echo -e "  ${_gg_dim}what:${_gg_reset}  ${best_desc}"
        echo ""

        # Show top 4 runners-up
        local -a runner_keys=() runner_scores=()
        for key in "${!_GG_REGISTRY[@]}"; do
            [[ "$key" == "$best_key" ]] && continue
            _gg_parse_entry "${_GG_REGISTRY[$key]}"
            local cmd_lower="${_gg_entry_cmd,,}"
            local desc_lower="${_gg_entry_desc,,}"
            local key_lower="${key,,}"
            local score=0
            if [[ "$cmd_lower" == *"$input_lower"* ]]; then (( score += 500 )); fi
            if [[ "$input_lower" == *"$cmd_lower"* && -n "$cmd_lower" ]]; then (( score += 400 )); fi
            if [[ "$key_lower" == "$input_lower" ]]; then (( score += 900 )); fi
            local word
            for word in $input_lower; do
                [[ "$cmd_lower" == *"$word"* ]] && (( score += 50 ))
                [[ "$desc_lower" == *"$word"* ]] && (( score += 30 ))
                [[ "$key_lower" == *"$word"* ]] && (( score += 40 ))
            done
            if (( score > 0 )); then
                runner_keys+=("$key")
                runner_scores+=("$score")
            fi
        done

        # Sort runners by score (simple selection sort, fine for small N)
        local n=${#runner_keys[@]}
        local ii jj tmp_k tmp_s
        for (( ii=0; ii<n-1; ii++ )); do
            for (( jj=ii+1; jj<n; jj++ )); do
                if (( runner_scores[jj] > runner_scores[ii] )); then
                    tmp_k="${runner_keys[ii]}"; runner_keys[ii]="${runner_keys[jj]}"; runner_keys[jj]="$tmp_k"
                    tmp_s="${runner_scores[ii]}"; runner_scores[ii]="${runner_scores[jj]}"; runner_scores[jj]="$tmp_s"
                fi
            done
        done

        if (( n > 0 )); then
            echo -e "  ${_gg_dim}see also:${_gg_reset}"
            local show=$(( n < 4 ? n : 4 ))
            for (( ii=0; ii<show; ii++ )); do
                _gg_parse_entry "${_GG_REGISTRY[${runner_keys[$ii]}]}"
                printf "    ${_gg_yellow}%-16s${_gg_reset} %s\n" "${runner_keys[$ii]}" "$_gg_entry_desc"
            done
            echo ""
        fi

        # Copy best match to clipboard
        if command -v pbcopy &>/dev/null; then
            echo -n "$best_key" | pbcopy
            _gg_info "Copied '${best_key}' to clipboard."
        elif command -v xclip &>/dev/null; then
            echo -n "$best_key" | xclip -selection clipboard
            _gg_info "Copied '${best_key}' to clipboard."
        fi
        return 0
    fi

    # ── G (no args): interactive autocomplete mode ──
    local query=""
    local -a names descriptions
    local key

    # Build sorted parallel arrays
    for key in $(echo "${!_GG_REGISTRY[@]}" | tr ' ' '\n' | sort); do
        names+=("$key")
        _gg_parse_entry "${_GG_REGISTRY[$key]}"
        descriptions+=("$_gg_entry_desc")
    done

    local total=${#names[@]}

    # --- Fuzzy match helper (pure bash, no deps) ---
    _gg_fuzzy_match() {
        local pattern="$1" text="$2"
        pattern="${pattern,,}"
        text="${text,,}"
        local i=0 j=0
        while (( i < ${#pattern} && j < ${#text} )); do
            if [[ "${pattern:$i:1}" == "${text:$j:1}" ]]; then
                (( i++ ))
            fi
            (( j++ ))
        done
        (( i == ${#pattern} ))
    }

    # --- Filter entries by query ---
    local -a filtered_names filtered_descs filtered_cmds
    _gg_filter() {
        local q="$1"
        filtered_names=()
        filtered_descs=()
        filtered_cmds=()
        local idx
        for (( idx=0; idx<total; idx++ )); do
            _gg_parse_entry "${_GG_REGISTRY[${names[$idx]}]}"
            if [ -z "$q" ] || _gg_fuzzy_match "$q" "${names[$idx]}" || _gg_fuzzy_match "$q" "$_gg_entry_desc" || _gg_fuzzy_match "$q" "$_gg_entry_cmd"; then
                filtered_names+=("${names[$idx]}")
                filtered_descs+=("$_gg_entry_desc")
                filtered_cmds+=("$_gg_entry_cmd")
            fi
        done
    }

    # --- Draw the UI ---
    _gg_draw() {
        local q="$1" sel="$2"
        local fcount=${#filtered_names[@]}
        local max_visible=15
        local start=0

        if (( sel >= max_visible )); then
            start=$(( sel - max_visible + 1 ))
        fi

        local lines_to_clear=$(( max_visible + 4 ))
        local i
        for (( i=0; i<lines_to_clear; i++ )); do
            printf '\033[2K\n'
        done
        printf "\033[${lines_to_clear}A"

        echo -e "${_gg_bold}${_gg_magenta}  G${_gg_reset}${_gg_dim} -- git-goblin shell${_gg_reset}  ${_gg_dim}(${fcount}/${total})${_gg_reset}"
        echo -ne "  ${_gg_cyan}>${_gg_reset} ${q}${_gg_dim}|${_gg_reset}"
        echo ""

        local end=$(( start + max_visible ))
        if (( end > fcount )); then end=$fcount; fi

        for (( i=start; i<end; i++ )); do
            if (( i == sel )); then
                printf "  ${_gg_bold}${_gg_green}> %-16s${_gg_reset} ${_gg_bold}%s${_gg_reset}\n" "${filtered_names[$i]}" "${filtered_descs[$i]}"
            else
                printf "  ${_gg_dim}  %-16s${_gg_reset} %s\n" "${filtered_names[$i]}" "${filtered_descs[$i]}"
            fi
        done

        for (( i=end; i < start + max_visible; i++ )); do
            printf '\033[2K\n'
        done

        echo -e "  ${_gg_dim}[arrows] navigate  [enter] select+show  [tab] copy  [esc] quit${_gg_reset}"
    }

    local selected=0
    _gg_filter "$query"

    printf '\033[?25l'
    trap 'printf "\033[?25h"; trap - RETURN' RETURN

    _gg_draw "$query" "$selected"

    while true; do
        local char
        IFS= read -rsn1 char

        if [[ "$char" == $'\x1b' ]]; then
            local seq
            IFS= read -rsn2 -t 0.05 seq
            case "$seq" in
                '[A') (( selected > 0 )) && (( selected-- )) ;;
                '[B') (( selected < ${#filtered_names[@]} - 1 )) && (( selected++ )) ;;
                '')
                    printf '\033[?25h'
                    echo ""
                    return 0
                    ;;
            esac
        elif [[ "$char" == '' ]]; then
            # Enter
            if (( ${#filtered_names[@]} > 0 )); then
                local chosen="${filtered_names[$selected]}"
                _gg_parse_entry "${_GG_REGISTRY[$chosen]}"
                printf '\033[?25h'
                echo ""
                echo ""
                echo -e "  ${_gg_green}${_gg_bold}${chosen}${_gg_reset}"
                echo -e "  ${_gg_dim}runs:${_gg_reset}  ${_gg_entry_cmd}"
                echo -e "  ${_gg_dim}what:${_gg_reset}  ${_gg_entry_desc}"
                echo ""
                if command -v pbcopy &>/dev/null; then
                    echo -n "$chosen" | pbcopy
                    _gg_info "Copied '${chosen}' to clipboard."
                elif command -v xclip &>/dev/null; then
                    echo -n "$chosen" | xclip -selection clipboard
                    _gg_info "Copied '${chosen}' to clipboard."
                fi
                return 0
            fi
        elif [[ "$char" == $'\x09' ]]; then
            # Tab -- copy without exiting
            if (( ${#filtered_names[@]} > 0 )); then
                local chosen="${filtered_names[$selected]}"
                if command -v pbcopy &>/dev/null; then
                    echo -n "$chosen" | pbcopy
                elif command -v xclip &>/dev/null; then
                    echo -n "$chosen" | xclip -selection clipboard
                fi
            fi
        elif [[ "$char" == $'\x7f' || "$char" == $'\x08' ]]; then
            if (( ${#query} > 0 )); then
                query="${query%?}"
                selected=0
                _gg_filter "$query"
            fi
        elif [[ "$char" == $'\x03' ]]; then
            printf '\033[?25h'
            echo ""
            return 1
        elif [[ "$char" =~ [[:print:]] ]]; then
            query+="$char"
            selected=0
            _gg_filter "$query"
        fi

        _gg_draw "$query" "$selected"
    done
}

# ============================================================================
# EXPORT ALL FUNCTIONS
# ============================================================================

export -f gg gclo jclo presto gwip gunwip gpristine gtag gpr gdiff-fancy
export -f h hl
export -f dst dust-kash date-file-maker swap mkcd extract tre ports sizeof
export -f blk serve jql
export -f G gg-help
