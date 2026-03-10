#!/bin/bash
# mega_script.sh - Git Aliases, Cloud/DevOps Shortcuts & File Management
# Usage: source mega_script.sh OR add to your ~/.bashrc or ~/.zshrc

# ============================================================================
# BASIC GIT OPERATIONS (1-16)
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
# BRANCHING (17-31)
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
alias gstm='git stash push -m'

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
# ADVANCED GIT OPERATIONS (92-101)
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
# DOCKER (102-121)
# ============================================================================

# 102. List running containers
alias dps='docker ps'

# 103. List all containers
alias dpsa='docker ps -a'

# 104. List images
alias di='docker images'

# 105. Remove a container
alias drm='docker rm'

# 106. Remove an image
alias drmi='docker rmi'

# 107. Force remove all containers
alias drmf='docker rm -f $(docker ps -aq) 2>/dev/null'

# 108. Remove all images
alias drmia='docker rmi $(docker images -q) 2>/dev/null'

# 109. Exec into container
dex() {
    if [ -z "$1" ]; then
        echo "Usage: dex <container> [shell]"
        return 1
    fi
    docker exec -it "$1" "${2:-bash}"
}

# 110. Follow container logs
alias dl='docker logs -f'

# 111. Stop all running containers
alias dstop='docker stop $(docker ps -aq) 2>/dev/null'

# 112. Prune everything
alias dprune='docker system prune -af'

# 113. Docker Compose shortcut
alias dc='docker compose'

# 114. Compose up (detached)
alias dcu='docker compose up -d'

# 115. Compose down
alias dcd='docker compose down'

# 116. Compose build
alias dcb='docker compose build'

# 117. Follow compose logs
alias dcl='docker compose logs -f'

# 118. Restart compose services
alias dcr='docker compose restart'

# 119. List volumes
alias dvls='docker volume ls'

# 120. List networks
alias dnls='docker network ls'

# 121. Build image from Dockerfile
dbuild() {
    if [ -z "$1" ]; then
        echo "Usage: dbuild <image_name> [path]"
        return 1
    fi
    docker build -t "$1" "${2:-.}"
}

# ============================================================================
# KUBERNETES (122-147)
# ============================================================================

# 122. kubectl shortcut
alias k='kubectl'

# 123. List pods
alias kgp='kubectl get pods'

# 124. List all pods across namespaces
alias kgpa='kubectl get pods --all-namespaces'

# 125. List services
alias kgs='kubectl get svc'

# 126. List nodes
alias kgn='kubectl get nodes'

# 127. List deployments
alias kgd='kubectl get deployments'

# 128. List ingresses
alias kgi='kubectl get ingress'

# 129. List namespaces
alias kgns='kubectl get namespaces'

# 130. List all resources
alias kga='kubectl get all'

# 131. Describe a pod
alias kdp='kubectl describe pod'

# 132. Describe a service
alias kds='kubectl describe svc'

# 133. Describe a deployment
alias kdd='kubectl describe deployment'

# 134. Follow pod logs
alias kl='kubectl logs -f'

# 135. Previous pod logs
alias klp='kubectl logs -f -p'

# 136. Exec into a pod
kex() {
    if [ -z "$1" ]; then
        echo "Usage: kex <pod> [shell]"
        return 1
    fi
    kubectl exec -it "$1" -- "${2:-bash}"
}

# 137. Apply a manifest
alias kaf='kubectl apply -f'

# 138. Delete from manifest
alias kdf='kubectl delete -f'

# 139. Show kube contexts
alias kctx='kubectl config get-contexts'

# 140. Switch kube context
alias kuse='kubectl config use-context'

# 141. Set default namespace
kns() {
    if [ -z "$1" ]; then
        echo "Usage: kns <namespace>"
        return 1
    fi
    kubectl config set-context --current --namespace="$1"
}

# 142. Port-forward to a pod
alias kpf='kubectl port-forward'

# 143. Scale a deployment
kscale() {
    if [ -z "$2" ]; then
        echo "Usage: kscale <deployment> <replicas>"
        return 1
    fi
    kubectl scale deployment "$1" --replicas="$2"
}

# 144. Check rollout status
alias krollout='kubectl rollout status deployment'

# 145. Restart a deployment
alias krestart='kubectl rollout restart deployment'

# 146. Pod resource usage
alias ktop='kubectl top pods'

# 147. Node resource usage
alias ktopn='kubectl top nodes'

# ============================================================================
# AWS CLI (148-162)
# ============================================================================

# 148. Show current AWS identity
alias awsid='aws sts get-caller-identity'

# 149. List S3 buckets
alias awsls='aws s3 ls'

# 150. Copy file to S3
alias awscp='aws s3 cp'

# 151. Sync directory to S3
alias awssync='aws s3 sync'

# 152. List EC2 instances
alias awsec2='aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId,State.Name,Tags[?Key==\`Name\`].Value|[0]]" --output table'

# 153. ECR docker login
awsecr() {
    local region="${1:-us-east-1}"
    local account
    account=$(aws sts get-caller-identity --query Account --output text)
    aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "${account}.dkr.ecr.${region}.amazonaws.com"
}

# 154. List Lambda functions
alias awslam='aws lambda list-functions --query "Functions[].FunctionName" --output table'

# 155. Tail CloudWatch logs
alias awslog='aws logs tail --follow'

# 156. List Elastic Beanstalk environments
alias awseb='aws elasticbeanstalk describe-environments --query "Environments[].[EnvironmentName,Status]" --output table'

# 157. List CloudFormation stacks
alias awscf='aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE --query "StackSummaries[].StackName" --output table'

# 158. List EKS clusters
alias awseks='aws eks list-clusters --output table'

# 159. List RDS instances
alias awsrds='aws rds describe-db-instances --query "DBInstances[].[DBInstanceIdentifier,DBInstanceStatus,Engine]" --output table'

# 160. SSM session to instance
alias awsssm='aws ssm start-session --target'

# 161. Show current IAM user
alias awswho='aws iam get-user'

# 162. List all AWS regions
alias awsregions='aws ec2 describe-regions --query "Regions[].RegionName" --output table'

# ============================================================================
# GCP / GCLOUD (163-177)
# ============================================================================

# 163. Show current GCP project
alias gcpid='gcloud config get-value project'

# 164. Set GCP project
alias gcpset='gcloud config set project'

# 165. List GCE instances
alias gcpls='gcloud compute instances list'

# 166. SSH into GCE instance
alias gcpssh='gcloud compute ssh'

# 167. List GKE clusters
alias gcpgke='gcloud container clusters list'

# 168. Get GKE kubeconfig
alias gcpgkecreds='gcloud container clusters get-credentials'

# 169. List BigQuery datasets
alias gcpbq='bq ls'

# 170. List GCS buckets
alias gcpgsutil='gsutil ls'

# 171. Copy file to GCS
alias gcpcp='gsutil cp'

# 172. Sync directory to GCS
alias gcpsync='gsutil -m rsync -r'

# 173. List Cloud Run services
alias gcprun='gcloud run services list'

# 174. List Cloud Functions
alias gcpfn='gcloud functions list'

# 175. List Cloud SQL instances
alias gcpsql='gcloud sql instances list'

# 176. Read GCP logs
alias gcplog='gcloud logging read --limit=50'

# 177. Authenticate with GCP
alias gcpauth='gcloud auth login'

# ============================================================================
# TERRAFORM (178-188)
# ============================================================================

# 178. Terraform shortcut
alias tf='terraform'

# 179. Initialize Terraform
alias tfi='terraform init'

# 180. Plan changes
alias tfp='terraform plan'

# 181. Apply changes
alias tfa='terraform apply'

# 182. Apply without prompt
alias tfaa='terraform apply -auto-approve'

# 183. Destroy infrastructure
alias tfd='terraform destroy'

# 184. List state resources
alias tfs='terraform state list'

# 185. Show outputs
alias tfo='terraform output'

# 186. Validate config
alias tfv='terraform validate'

# 187. Format all .tf files
alias tff='terraform fmt -recursive'

# 188. List workspaces
alias tfw='terraform workspace list'

# ============================================================================
# HELM / ANSIBLE / VAGRANT (189-195)
# ============================================================================

# 189. Helm upgrade/install
alias hup='helm upgrade --install'

# 190. List Helm releases
alias hls='helm list'

# 191. Uninstall Helm release
alias hdel='helm uninstall'

# 192. Run Ansible playbook
alias ans='ansible-playbook'

# 193. Start Vagrant VM
alias vup='vagrant up'

# 194. SSH into Vagrant VM
alias vsh='vagrant ssh'

# 195. Stop Vagrant VM
alias vhalt='vagrant halt'

# ============================================================================
# FUNCTIONS - Complex Git Operations
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
    if [ -z "$1" ]; then
        echo "Usage: ghcl <username/repo>"
        return 1
    fi
    git clone "https://github.com/$1"
}

# Create branch and switch to it
gbc() {
    if [ -z "$1" ]; then
        echo "Usage: gbc <branch_name>"
        return 1
    fi
    git checkout -b "$1"
}

# Delete branch both locally and remotely
gbdall() {
    if [ -z "$1" ]; then
        echo "Usage: gbdall <branch_name>"
        return 1
    fi
    git branch -d "$1" && git push origin --delete "$1"
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
    if [ -z "$1" ]; then
        echo "Usage: gnew <branch_name>"
        return 1
    fi
    git fetch origin && git checkout -b "$1" origin/main
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
    git fetch upstream && \
    git checkout main && \
    git merge upstream/main && \
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
# NPM / YARN / PNPM (196-225)
# ============================================================================

# 196. npm install
alias ni='npm install'

# 197. npm install save-dev
alias nid='npm install --save-dev'

# 198. npm install global
alias nig='npm install -g'

# 199. npm run dev
alias nrd='npm run dev'

# 200. npm run build
alias nrb='npm run build'

# 201. npm run start
alias nrs='npm run start'

# 202. npm run test
alias nrt='npm run test'

# 203. npm run lint
alias nrl='npm run lint'

# 204. npm list (top-level)
alias nls='npm list --depth=0'

# 205. npm outdated
alias nout='npm outdated'

# 206. npm update
alias nup='npm update'

# 207. npm audit fix
alias naf='npm audit fix'

# 208. npm cache clean
alias ncc='npm cache clean --force'

# 209. npm init -y
alias ninit='npm init -y'

# 210. npx shortcut
alias nx='npx'

# 211. yarn install
alias yi='yarn install'

# 212. yarn add
alias ya='yarn add'

# 213. yarn add dev
alias yad='yarn add --dev'

# 214. yarn dev
alias yrd='yarn dev'

# 215. yarn build
alias yrb='yarn build'

# 216. yarn start
alias yrs='yarn start'

# 217. yarn test
alias yrt='yarn test'

# 218. yarn global add
alias yga='yarn global add'

# 219. pnpm install
alias pi='pnpm install'

# 220. pnpm add
alias pad='pnpm add'

# 221. pnpm add dev
alias padd='pnpm add -D'

# 222. pnpm dev
alias prd='pnpm dev'

# 223. pnpm build
alias prb='pnpm build'

# 224. pnpm start
alias prs='pnpm start'

# 225. pnpm test
alias prt='pnpm test'

# ============================================================================
# PYTHON / PIP / VENV (226-245)
# ============================================================================

# 226. Python3 shortcut
alias py='python3'

# 227. Python2 shortcut
alias py2='python2'

# 228. pip install
alias pip3i='pip3 install'

# 229. pip install requirements
alias pipr='pip3 install -r requirements.txt'

# 230. pip freeze to requirements
alias pipf='pip3 freeze > requirements.txt'

# 231. pip list installed
alias pipl='pip3 list'

# 232. pip list outdated
alias pipo='pip3 list --outdated'

# 233. pip upgrade package
alias pipu='pip3 install --upgrade'

# 234. pip uninstall
alias pipun='pip3 uninstall'

# 235. Create venv
alias venv='python3 -m venv venv'

# 236. Activate venv
alias va='source venv/bin/activate'

# 237. Deactivate venv
alias vd='deactivate'

# 238. pytest shortcut
alias pt='pytest'

# 239. pytest verbose
alias ptv='pytest -v'

# 240. pytest with coverage
alias ptc='pytest --cov'

# 241. Run Python module
alias pym='python3 -m'

# 242. IPython shortcut
alias ipy='ipython'

# 243. Jupyter notebook
alias jnb='jupyter notebook'

# 244. Jupyter lab
alias jlab='jupyter lab'

# 245. pip install editable
alias pide='pip3 install -e .'

# ============================================================================
# SYSTEMD / SERVICES (246-260)
# ============================================================================

# 246. systemctl status
alias scs='sudo systemctl status'

# 247. systemctl start
alias scstart='sudo systemctl start'

# 248. systemctl stop
alias scstop='sudo systemctl stop'

# 249. systemctl restart
alias screstart='sudo systemctl restart'

# 250. systemctl enable
alias scenable='sudo systemctl enable'

# 251. systemctl disable
alias scdisable='sudo systemctl disable'

# 252. systemctl reload
alias screload='sudo systemctl reload'

# 253. systemctl daemon-reload
alias scdaemon='sudo systemctl daemon-reload'

# 254. journalctl follow
alias jctl='sudo journalctl -f'

# 255. journalctl for a unit
alias jctlu='sudo journalctl -u'

# 256. journalctl since today
alias jctlt='sudo journalctl --since today'

# 257. systemctl list-units
alias scls='systemctl list-units --type=service'

# 258. systemctl list-failed
alias scfail='systemctl --failed'

# 259. systemctl is-active
alias scactive='systemctl is-active'

# 260. systemctl is-enabled
alias scenabled='systemctl is-enabled'

# ============================================================================
# NETWORKING (261-280)
# ============================================================================

# 261. curl with timing
alias curlt='curl -o /dev/null -s -w "DNS: %{time_namelookup}s | Connect: %{time_connect}s | TLS: %{time_appconnect}s | Total: %{time_total}s\n"'

# 262. curl GET with headers
alias curlh='curl -I'

# 263. curl POST JSON
curlj() {
    if [ -z "$2" ]; then
        echo "Usage: curlj URL '{\"key\":\"val\"}'"
        return 1
    fi
    curl -s -X POST -H "Content-Type: application/json" -d "$2" "$1" | jq . 2>/dev/null || cat
}

# 264. wget mirror a site
alias wgetm='wget --mirror --convert-links --adjust-extension --page-requisites --no-parent'

# 265. Show public IP
alias myip='curl -s https://ifconfig.me && echo'

# 266. Show local IP
alias localip='ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | awk "{print \$1}"'

# 267. Ping (5 packets)
alias ping5='ping -c 5'

# 268. DNS lookup
alias digs='dig +short'

# 269. Reverse DNS lookup
alias digr='dig -x'

# 270. nslookup shortcut
alias nsl='nslookup'

# 271. Traceroute
alias trace='traceroute'

# 272. netstat listening ports
alias nstat='netstat -tlnp 2>/dev/null || netstat -an | grep LISTEN'

# 273. SS listening ports
alias ssl='ss -tlnp'

# 274. Show open connections
alias conns='ss -s'

# 275. Check if a port is open
portcheck() {
    if [ -z "$2" ]; then
        echo "Usage: portcheck HOST PORT"
        return 1
    fi
    nc -zv "$1" "$2" 2>&1
}

# 276. Speed test (uses curl)
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# 277. Show all network interfaces
alias ifls='ifconfig 2>/dev/null || ip addr show'

# 278. HTTP headers for URL
alias headers='curl -sI'

# 279. Download file with progress
alias dlf='curl -L -O --progress-bar'

# 280. Whois lookup
alias whois='whois'

# ============================================================================
# REDIS (281-292)
# ============================================================================

# 281. Redis CLI
alias rd='redis-cli'

# 282. Redis ping
alias rdping='redis-cli ping'

# 283. Redis info
alias rdinfo='redis-cli info'

# 284. Redis monitor
alias rdmon='redis-cli monitor'

# 285. Redis all keys
alias rdkeys='redis-cli keys "*"'

# 286. Redis get
alias rdget='redis-cli get'

# 287. Redis set
alias rdset='redis-cli set'

# 288. Redis delete
alias rddel='redis-cli del'

# 289. Redis flush current db
alias rdflush='redis-cli flushdb'

# 290. Redis flush all
alias rdflushall='redis-cli flushall'

# 291. Redis db size
alias rdsize='redis-cli dbsize'

# 292. Redis server shutdown
alias rdshut='redis-cli shutdown'

# ============================================================================
# POSTGRES (293-307)
# ============================================================================

# 293. psql shortcut
alias pg='psql'

# 294. psql as postgres user
alias pgsu='sudo -u postgres psql'

# 295. List databases
alias pgls='psql -l'

# 296. Connect to database
pgdb() {
    if [ -z "$1" ]; then
        echo "Usage: pgdb <database> [user]"
        return 1
    fi
    psql -d "$1" ${2:+-U "$2"}
}

# 297. pg_dump a database
alias pgdump='pg_dump'

# 298. pg_restore
alias pgrestore='pg_restore'

# 299. Create database
alias pgcreate='createdb'

# 300. Drop database
alias pgdrop='dropdb'

# 301. List roles
alias pgroles='psql -c "\\du"'

# 302. Show connections
alias pgconn='psql -c "SELECT pid, usename, datname, state FROM pg_stat_activity;"'

# 303. Show table sizes
alias pgsize='psql -c "SELECT relname, pg_size_pretty(pg_total_relation_size(relid)) FROM pg_catalog.pg_statio_user_tables ORDER BY pg_total_relation_size(relid) DESC;"'

# 304. Show running queries
alias pgrunning='psql -c "SELECT pid, now()-pg_stat_activity.query_start AS duration, query FROM pg_stat_activity WHERE state = '\''active'\'' ORDER BY duration DESC;"'

# 305. Vacuum full
alias pgvacuum='psql -c "VACUUM FULL;"'

# 306. PostgreSQL service status (Linux)
alias pgstatus='sudo systemctl status postgresql 2>/dev/null || brew services info postgresql 2>/dev/null'

# 307. PostgreSQL version
alias pgver='psql --version'

# ============================================================================
# NGINX (308-318)
# ============================================================================

# 308. Test nginx config
alias ngt='sudo nginx -t'

# 309. Reload nginx
alias ngr='sudo nginx -s reload'

# 310. Start nginx
alias ngstart='sudo systemctl start nginx 2>/dev/null || sudo nginx'

# 311. Stop nginx
alias ngstop='sudo systemctl stop nginx 2>/dev/null || sudo nginx -s stop'

# 312. Restart nginx
alias ngrestart='sudo systemctl restart nginx 2>/dev/null || sudo nginx -s quit && sudo nginx'

# 313. Nginx status
alias ngstatus='sudo systemctl status nginx 2>/dev/null || ps aux | grep nginx'

# 314. Edit nginx config
alias ngedit='sudo ${EDITOR:-vi} /etc/nginx/nginx.conf'

# 315. Tail nginx access log
alias ngacc='sudo tail -f /var/log/nginx/access.log'

# 316. Tail nginx error log
alias ngerr='sudo tail -f /var/log/nginx/error.log'

# 317. List nginx sites-enabled
alias ngsites='ls -la /etc/nginx/sites-enabled/ 2>/dev/null || ls -la /etc/nginx/conf.d/'

# 318. Nginx main config dump
alias ngconf='sudo nginx -T'

# ============================================================================
# MISC CLI TOOLS (319-340)
# ============================================================================

# 319. Quick top/htop
alias top='htop 2>/dev/null || top'

# 320. Disk usage summary
alias duh='du -sh * | sort -rh'

# 321. Disk free human-readable
alias dfh='df -h'

# 322. Free memory (Linux)
alias fmem='free -h 2>/dev/null || vm_stat'

# 323. CPU info
alias cpuinfo='lscpu 2>/dev/null || sysctl -a | grep machdep.cpu'

# 324. Watch a command (every 2s)
alias w2='watch -n 2'

# 325. List open files by process
alias lsofp='lsof -c'

# 326. Kill process by name
alias killname='pkill -f'

# 327. Find process by name
alias pgrep='pgrep -fl'

# 328. History shortcut
alias hist='history | tail -50'

# 329. Clear terminal
alias cl='clear'

# 330. Reload shell config
alias reload='exec $SHELL -l'

# 331. Edit shell config
alias erc='${EDITOR:-vi} ~/.${SHELL##*/}rc'

# 332. Show PATH entries (one per line)
alias path='echo $PATH | tr ":" "\n"'

# 333. Make executable
alias cx='chmod +x'

# 334. Timestamp (epoch)
alias epoch='date +%s'

# 335. Timestamp ISO
alias isodate='date -u +"%Y-%m-%dT%H:%M:%SZ"'

# 336. UUID generator
alias uuid='python3 -c "import uuid; print(uuid.uuid4())"'

# 337. Base64 encode
alias b64e='base64'

# 338. Base64 decode
alias b64d='base64 --decode'

# 339. SHA256 hash of file
alias sha256='shasum -a 256'

# 340. MD5 hash of file
alias md5sum='md5 2>/dev/null || md5sum'

# ============================================================================
# CYBERSECURITY / NETWORK RECON (341-380)
# ============================================================================

# 341. Telnet
alias tn='telnet'

# 342. Telnet to host:port (quick connectivity check)
tnp() {
    if [ -z "$2" ]; then
        echo "Usage: tnp HOST PORT"
        return 1
    fi
    telnet "$1" "$2"
}

# 343. Netstat all connections
alias nsa='netstat -an'

# 344. Netstat listening TCP
alias nstcp='netstat -tlnp 2>/dev/null || netstat -an -p tcp | grep LISTEN'

# 345. Netstat listening UDP
alias nsudp='netstat -ulnp 2>/dev/null || netstat -an -p udp'

# 346. Netstat with process info
alias nsproc='netstat -tulnp 2>/dev/null || lsof -i -P -n'

# 347. Netstat established connections
alias nsest='netstat -an | grep ESTABLISHED'

# 348. Nmap quick scan (top 100 ports)
alias nquick='nmap -F'

# 349. Nmap full TCP port scan
alias nfull='nmap -p-'

# 350. Nmap service version detection
alias nsvc='nmap -sV'

# 351. Nmap OS detection (requires root)
alias nos='sudo nmap -O'

# 352. Nmap aggressive scan (OS + version + scripts + traceroute)
alias nagg='sudo nmap -A'

# 353. Nmap stealth SYN scan
alias nsyn='sudo nmap -sS'

# 354. Nmap UDP scan
alias nudp='sudo nmap -sU'

# 355. Nmap ping sweep (discover hosts on subnet)
alias nsweep='nmap -sn'

# 356. Nmap vulnerability scan (default scripts)
alias nvuln='nmap --script vuln'

# 357. Nmap scan specific ports
nports() {
    if [ -z "$2" ]; then
        echo "Usage: nports HOST 'PORT1,PORT2,...'"
        return 1
    fi
    nmap -p "$2" "$1"
}

# 358. Nmap scan with all scripts
alias nscript='nmap -sC'

# 359. Nmap XML output for parsing
nmapxml() {
    if [ -z "$1" ]; then
        echo "Usage: nmapxml HOST [output.xml]"
        return 1
    fi
    nmap -oX "${2:-scan-$(date +%Y%m%d-%H%M%S).xml}" "$1"
}

# 360. Netcat listen on port
ncl() {
    if [ -z "$1" ]; then
        echo "Usage: ncl PORT"
        return 1
    fi
    nc -lvp "$1" 2>/dev/null || nc -l "$1"
}

# 361. Netcat send data to host:port
ncs() {
    if [ -z "$2" ]; then
        echo "Usage: ncs HOST PORT"
        return 1
    fi
    nc "$1" "$2"
}

# 362. Port scan with netcat (no nmap)
ncscan() {
    if [ -z "$2" ]; then
        echo "Usage: ncscan HOST 'START-END' (e.g., ncscan 10.0.0.1 '1-1024')"
        return 1
    fi
    nc -zv "$1" "$2" 2>&1
}

# 363. Check SSL/TLS certificate for a domain
sslcheck() {
    if [ -z "$1" ]; then
        echo "Usage: sslcheck DOMAIN"
        return 1
    fi
    echo | openssl s_client -servername "$1" -connect "$1:443" 2>/dev/null | openssl x509 -noout -dates -subject -issuer
}

# 364. Show full SSL cert chain
sslchain() {
    if [ -z "$1" ]; then
        echo "Usage: sslchain DOMAIN"
        return 1
    fi
    echo | openssl s_client -showcerts -servername "$1" -connect "$1:443" 2>/dev/null
}

# 365. SSL cipher enumeration
sslciphers() {
    if [ -z "$1" ]; then
        echo "Usage: sslciphers DOMAIN"
        return 1
    fi
    nmap --script ssl-enum-ciphers -p 443 "$1"
}

# 366. Banner grabbing (via netcat)
bannergrab() {
    if [ -z "$2" ]; then
        echo "Usage: bannergrab HOST PORT"
        return 1
    fi
    echo "" | nc -w 3 "$1" "$2" 2>&1
}

# 367. Show open TCP ports on this host
alias myports='lsof -i -P -n | grep LISTEN'

# 368. ARP table
alias arptable='arp -a'

# 369. Show routing table
alias routes='netstat -rn 2>/dev/null || ip route show'

# 370. Show firewall rules (Linux iptables)
alias fwrules='sudo iptables -L -n -v 2>/dev/null || sudo pfctl -sr 2>/dev/null'

# 371. tcpdump on interface (requires root)
alias sniff='sudo tcpdump -i any -nn'

# 372. tcpdump capture to file
tcapt() {
    if [ -z "$1" ]; then
        echo "Usage: tcapt INTERFACE [output.pcap]"
        return 1
    fi
    sudo tcpdump -i "$1" -w "${2:-capture-$(date +%Y%m%d-%H%M%S).pcap}"
}

# 373. tcpdump filter by port
tcport() {
    if [ -z "$1" ]; then
        echo "Usage: tcport PORT [interface]"
        return 1
    fi
    sudo tcpdump -i "${2:-any}" -nn port "$1"
}

# 374. tcpdump filter by host
tchost() {
    if [ -z "$1" ]; then
        echo "Usage: tchost HOST [interface]"
        return 1
    fi
    sudo tcpdump -i "${2:-any}" -nn host "$1"
}

# 375. HTTP security headers check
secheaders() {
    if [ -z "$1" ]; then
        echo "Usage: secheaders URL"
        return 1
    fi
    curl -sI "$1" | grep -iE '(strict-transport|content-security|x-frame|x-content|x-xss|referrer-policy|permissions-policy|feature-policy)'
}

# 376. Hash a password with sha512
hashpw() {
    if [ -z "$1" ]; then
        echo "Usage: hashpw PASSWORD"
        return 1
    fi
    echo -n "$1" | openssl dgst -sha512
}

# 377. Generate a random password
genpw() {
    local len="${1:-32}"
    LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()_+=' < /dev/urandom | head -c "$len" && echo
}

# 378. Find world-writable files (potential security issue)
alias worldwrite='find / -xdev -type f -perm -0002 -ls 2>/dev/null'

# 379. Find SUID binaries
alias findsuid='find / -xdev -type f -perm -4000 -ls 2>/dev/null'

# 380. Show all logged-in users
alias whoson='who -a 2>/dev/null || w'
