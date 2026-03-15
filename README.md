# git-goblin

Git Scripts that Get the Job Done!

![ggob.jpeg](ggob.jpeg)

**380+ shell shortcuts** for Git, Docker, Kubernetes, AWS, GCP, Terraform, Helm, Ansible, Vagrant, npm/yarn/pnpm, Python/pip, systemd, networking, Redis, Postgres, nginx, cybersecurity/recon, and everyday CLI tools -- all searchable through the `G` command.

---

## Installation

### Quick Setup (Recommended)

```bash
git clone https://github.com/juleshenry/git-goblin.git
cd git-goblin
chmod +x setup-git-goblin
./setup-git-goblin
source ~/.bashrc  # or source ~/.zshrc
```

### One-Liner

```bash
git clone https://github.com/juleshenry/git-goblin.git && cd git-goblin && chmod +x setup-git-goblin && ./setup-git-goblin && source ~/.bashrc
```

### Manual Setup

If you prefer not to run the installer, add these two lines to your `~/.bashrc` or `~/.zshrc`:

```bash
source /path/to/git-goblin/git-goblin-functions.sh
source /path/to/git-goblin/mega_script.sh
```

Then reload: `source ~/.bashrc`

### What the Installer Does

- Detects your shell (bash or zsh) and finds the right RC file
- Backs up your RC file before making any changes
- Removes old alias-based configs if migrating from an earlier version
- Adds source lines for `git-goblin-functions.sh` and `mega_script.sh`
- Makes all scripts executable

### Uninstall

```bash
cd /path/to/git-goblin
./setup-git-goblin --remove
source ~/.bashrc
```

This cleanly removes the git-goblin block from your RC file. Your backup is preserved.

---

## G -- The Git-Goblin Shell

`G` is the brain of git-goblin. It has three modes:

### 1. Best-Guess Mode: `G 'command'`

Pass any raw CLI command and `G` scores every registered shortcut to find the closest match. It shows the shortcut name, the underlying command, a doc blurb, and runners-up.

```bash
G 'git status'
#  G best guess for 'git status'
#  ────────────────────────────────────────────
#
#  gs
#  runs:  git status
#  what:  Show working tree status
#
#  see also:
#    gss              Short-format status
#    ginfo            Show repo info summary
#    gdfiles          List changed filenames

G 'docker logs'
#  dl
#  runs:  docker logs -f CONTAINER
#  what:  Follow container logs

G 'kubectl get pods'
#  kgp
#  runs:  kubectl get pods
#  what:  List pods

G 'terraform plan'
#  tfp
#  runs:  terraform plan
#  what:  Plan changes
```

The best match is automatically copied to your clipboard (macOS pbcopy / Linux xclip).

#### More G Examples -- npm, Python, Networking, Security

```bash
G 'npm install'
#  ni
#  runs:  npm install
#  what:  npm install
#
#  see also:
#    nid              npm install as dev dependency
#    nig              npm install globally
#    ninit            Initialize new npm project

G 'yarn add'
#  ya
#  runs:  yarn add PACKAGE
#  what:  Yarn add package

G 'pnpm dev'
#  prd
#  runs:  pnpm dev
#  what:  pnpm dev server

G 'pip install'
#  pip3i
#  runs:  pip3 install PACKAGE
#  what:  pip install a package
#
#  see also:
#    pipr             pip install from requirements
#    pipu             Upgrade a pip package
#    pide             pip install in editable mode

G 'python venv'
#  venv
#  runs:  python3 -m venv venv
#  what:  Create a virtual environment
#
#  see also:
#    va               Activate venv
#    vd               Deactivate venv

G 'pytest'
#  pt
#  runs:  pytest
#  what:  Run pytest
#
#  see also:
#    ptv              Run pytest verbose
#    ptc              Run pytest with coverage

G 'systemctl restart'
#  screstart
#  runs:  sudo systemctl restart SERVICE
#  what:  Restart a service

G 'curl POST json'
#  curlj
#  runs:  curl -X POST -H JSON -d DATA URL
#  what:  curl POST with JSON body

G 'dns lookup'
#  digs
#  runs:  dig +short DOMAIN
#  what:  Quick DNS lookup
#
#  see also:
#    nsl              nslookup shortcut
#    digr             Reverse DNS lookup

G 'my public ip'
#  myip
#  runs:  curl ifconfig.me
#  what:  Show public IP address

G 'redis keys'
#  rdkeys
#  runs:  redis-cli keys '*'
#  what:  List all Redis keys

G 'postgres connections'
#  pgconn
#  runs:  SELECT from pg_stat_activity
#  what:  Show active connections

G 'nginx reload'
#  ngr
#  runs:  sudo nginx -s reload
#  what:  Reload nginx

G 'port scan'
#  nquick
#  runs:  nmap -F HOST
#  what:  Nmap quick scan (top 100 ports)
#
#  see also:
#    nfull            Nmap full TCP port scan
#    ncscan           Port scan with netcat
#    portcheck        Check if a port is open

G 'nmap vulnerability'
#  nvuln
#  runs:  nmap --script vuln HOST
#  what:  Nmap vulnerability scan

G 'ssl certificate'
#  sslcheck
#  runs:  openssl s_client + x509 DOMAIN
#  what:  Check SSL certificate info
#
#  see also:
#    sslchain         Show full SSL cert chain
#    sslciphers       Enumerate SSL ciphers

G 'tcpdump'
#  sniff
#  runs:  sudo tcpdump -i any -nn
#  what:  Packet sniffing (tcpdump)
#
#  see also:
#    tcapt            Capture packets to file
#    tcport           tcpdump filter by port
#    tchost           tcpdump filter by host

G 'banner grab'
#  bannergrab
#  runs:  nc -w 3 HOST PORT
#  what:  Banner grab via netcat

G 'generate password'
#  genpw
#  runs:  tr -dc A-Za-z0-9... < /dev/urandom
#  what:  Generate random password

G 'netstat listening'
#  nstcp
#  runs:  netstat -tlnp
#  what:  Netstat listening TCP ports
#
#  see also:
#    nstat            Show listening ports (netstat)
#    ssl              Show listening ports (ss)
#    myports          Show open ports on this host

G 'telnet'
#  tn
#  runs:  telnet HOST
#  what:  Telnet to a host

G 'base64'
#  b64e
#  runs:  base64 FILE
#  what:  Base64 encode
#
#  see also:
#    b64d             Base64 decode

G 'uuid'
#  uuid
#  runs:  python3 uuid4
#  what:  Generate a UUID
```

#### Partial and Misspelled Queries

`G` uses word-overlap scoring, so partial matches still work:

```bash
G 'push force'    # -> gpf (git push --force)
G 'stash pop'     # -> gstpo (git stash pop)
G 'compose up'    # -> dcu (docker compose up -d)
G 'branch delete' # -> gbd (git branch -d BRANCH)
G 'pods all'      # -> kgpa (kubectl get pods --all-namespaces)
G 'commit amend'  # -> gcam (git commit --amend -m MSG)
```

### 2. Add Mode: `G -a 'command' 'description'`

Add your own custom shortcuts on the fly. They persist across sessions in `~/.git-goblin-custom`.

```bash
G -a 'docker stats' 'Live container resource usage'
# [ok] Added: docker stats -- Live container resource usage
# [..] Saved to ~/.git-goblin-custom (persists across sessions).

G -a 'npm run dev' 'Start local dev server'
# [ok] Added: npm run dev -- Start local dev server

G -a 'ssh -L 8080:localhost:80 server' 'SSH tunnel port 80 to local 8080'
# [ok] Added

G -a 'rsync -avz src/ dest/' 'Rsync with compression'
# [ok] Added
```

After adding, these show up in `G` lookups and interactive mode immediately.

### 3. Interactive Mode: `G` (no args)

Launches a full-screen fuzzy-find TUI over every registered command:

```
  G -- git-goblin shell  (380/380)
  > docker|

  > dps              List running containers
    dpsa             List all containers
    di               List images
    dex              Exec into container
    dl               Follow container logs
    ...

  [arrows] navigate  [enter] select+show  [tab] copy  [esc] quit
```

Type to filter, arrows to navigate, Enter to see full details, Tab to copy, Esc to quit. Fuzzy matching -- you don't need exact strings.

### gg-help: Built-in Reference

```bash
gg-help             # show everything
gg-help docker      # filter to docker commands
gg-help kubernetes  # filter to k8s commands
gg-help aws         # filter to AWS commands
gg-help terraform   # filter to terraform commands
gg-help npm         # filter to npm/yarn/pnpm commands
gg-help python      # filter to python/pip commands
gg-help redis       # filter to redis commands
gg-help nmap        # filter to security/recon commands
gg-help nginx       # filter to nginx commands
```

---

## Git Workflow Commands

| Command | What it does |
|---------|-------------|
| `gg "msg"` | `git add . && commit && push` in one shot |
| `gacp "msg"` | Same as `gg` (alias) |
| `gclo user/repo` | `git clone https://github.com/user/repo` |
| `jclo repo` | Clone from `juleshenry/repo` |
| `presto` | **DESTRUCTIVE**: wipe all git history, fresh start |
| `gwip` | Quick WIP commit with timestamp (no push) |
| `gunwip` | Undo last WIP commit, keep changes staged |
| `gpristine` | Hard-reset to match remote exactly |
| `gtag v1.0 "msg"` | Create + push an annotated tag |
| `gpr "title"` | Create a GitHub PR via `gh` CLI |
| `gdiff-fancy` | Pretty diff summary with stats |
| `ginit` | `git init` with initial commit |
| `ghcl user/repo` | Clone from GitHub |
| `gbc branch` | Create + checkout new branch |
| `gbdall branch` | Delete branch locally and remotely |
| `gundo` | Undo last commit, keep changes staged |
| `gbs` | Branches sorted by last modified |
| `gquick` | Commit + push with auto-timestamp |
| `gchanged N` | Files changed in last N commits |
| `gsearchtext "text"` | Search for string across git history |
| `gnew branch` | New branch from `origin/main` |
| `gupdateall` | Fetch all remotes + pull |
| `greposize` | Repo object storage size |
| `gfilesize` | List tracked files by size |
| `glarge N` | Find N largest blobs in history |
| `gsyncfork` | Sync fork with upstream/main |
| `gsquash N "msg"` | Squash last N commits |
| `gstats` | Commit count by author |
| `garchive branch` | Archive branch as tag, delete it |
| `galias` | List all `g*` aliases |
| `ginfo` | Repo name, branch, remote, last commit |
| `gbackup` | Tar.gz backup of current repo |

## Git Aliases (101 shortcuts)

All from `mega_script.sh`. Examples:

| Alias | Expands to |
|-------|-----------|
| `gs` | `git status` |
| `gss` | `git status -s` |
| `ga` | `git add .` |
| `gc` | `git commit -m` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `glr` | `git pull --rebase` |
| `gb` | `git branch` |
| `gco` | `git checkout` |
| `gcob` | `git checkout -b` |
| `gcom` | `git checkout main` |
| `gsw` | `git switch` |
| `gm` | `git merge` |
| `glog` | `git log --oneline --decorate --graph` |
| `glast` | `git log -1 HEAD` |
| `gblame` | `git blame` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `gdlc` | `git diff HEAD^ HEAD` |
| `gst` | `git stash` |
| `gstpo` | `git stash pop` |
| `gf` | `git fetch` |
| `gcl` | `git clone` |
| `grss` | `git reset --soft HEAD~1` |
| `grsh` | `git reset --hard HEAD~1` |
| `gcp` | `git cherry-pick` |
| `grbi` | `git rebase -i` |
| `gt` | `git tag` |
| `gpt` | `git push --tags` |

Run `gg-help` or `gg-help git` for the full list.

---

## Docker Shortcuts (20 commands)

| Command | What it does |
|---------|-------------|
| `dps` | `docker ps` -- list running containers |
| `dpsa` | `docker ps -a` -- list all containers |
| `di` | `docker images` -- list images |
| `drm` | `docker rm` -- remove a container |
| `drmi` | `docker rmi` -- remove an image |
| `drmf` | Force-remove all containers |
| `drmia` | Remove all images |
| `dex CONTAINER` | `docker exec -it CONTAINER bash` |
| `dl` | `docker logs -f` -- follow logs |
| `dstop` | Stop all running containers |
| `dprune` | `docker system prune -af` |
| `dc` | `docker compose` |
| `dcu` | `docker compose up -d` |
| `dcd` | `docker compose down` |
| `dcb` | `docker compose build` |
| `dcl` | `docker compose logs -f` |
| `dcr` | `docker compose restart` |
| `dvls` | `docker volume ls` |
| `dnls` | `docker network ls` |
| `dbuild NAME` | `docker build -t NAME .` |

---

## Kubernetes Shortcuts (26 commands)

| Command | What it does |
|---------|-------------|
| `k` | `kubectl` |
| `kgp` | `kubectl get pods` |
| `kgpa` | `kubectl get pods --all-namespaces` |
| `kgs` | `kubectl get svc` |
| `kgn` | `kubectl get nodes` |
| `kgd` | `kubectl get deployments` |
| `kgi` | `kubectl get ingress` |
| `kgns` | `kubectl get namespaces` |
| `kga` | `kubectl get all` |
| `kdp` | `kubectl describe pod` |
| `kds` | `kubectl describe svc` |
| `kdd` | `kubectl describe deployment` |
| `kl POD` | `kubectl logs -f POD` |
| `klp POD` | Previous container logs |
| `kex POD` | `kubectl exec -it POD -- bash` |
| `kaf FILE` | `kubectl apply -f FILE` |
| `kdf FILE` | `kubectl delete -f FILE` |
| `kctx` | List kube contexts |
| `kuse CTX` | Switch kube context |
| `kns NS` | Set default namespace |
| `kpf` | `kubectl port-forward` |
| `kscale DEP N` | Scale deployment to N replicas |
| `krollout DEP` | Check rollout status |
| `krestart DEP` | Restart a deployment |
| `ktop` | Pod resource usage |
| `ktopn` | Node resource usage |

---

## AWS CLI Shortcuts (15 commands)

| Command | What it does |
|---------|-------------|
| `awsid` | `aws sts get-caller-identity` |
| `awsls` | `aws s3 ls` -- list S3 buckets |
| `awscp` | `aws s3 cp` -- copy to S3 |
| `awssync` | `aws s3 sync` -- sync dir to S3 |
| `awsec2` | List EC2 instances (table) |
| `awsecr [region]` | ECR docker login |
| `awslam` | List Lambda functions |
| `awslog LOG_GROUP` | Tail CloudWatch logs |
| `awseb` | List Elastic Beanstalk environments |
| `awscf` | List CloudFormation stacks |
| `awseks` | List EKS clusters |
| `awsrds` | List RDS instances |
| `awsssm INSTANCE` | SSM session to EC2 |
| `awswho` | Show current IAM user |
| `awsregions` | List all AWS regions |

---

## GCP / gcloud Shortcuts (15 commands)

| Command | What it does |
|---------|-------------|
| `gcpid` | Show current GCP project |
| `gcpset PROJECT` | Set GCP project |
| `gcpls` | List GCE instances |
| `gcpssh INSTANCE` | SSH into GCE instance |
| `gcpgke` | List GKE clusters |
| `gcpgkecreds CLUSTER` | Get GKE kubeconfig |
| `gcpbq` | List BigQuery datasets |
| `gcpgsutil` | List GCS buckets |
| `gcpcp` | Copy file to GCS |
| `gcpsync` | Sync directory to GCS |
| `gcprun` | List Cloud Run services |
| `gcpfn` | List Cloud Functions |
| `gcpsql` | List Cloud SQL instances |
| `gcplog` | Read GCP logs |
| `gcpauth` | `gcloud auth login` |

---

## Terraform Shortcuts (11 commands)

| Command | What it does |
|---------|-------------|
| `tf` | `terraform` |
| `tfi` | `terraform init` |
| `tfp` | `terraform plan` |
| `tfa` | `terraform apply` |
| `tfaa` | `terraform apply -auto-approve` |
| `tfd` | `terraform destroy` |
| `tfs` | `terraform state list` |
| `tfo` | `terraform output` |
| `tfv` | `terraform validate` |
| `tff` | `terraform fmt -recursive` |
| `tfw` | `terraform workspace list` |

---

## Helm / Ansible / Vagrant (7 commands)

| Command | What it does |
|---------|-------------|
| `hup` | `helm upgrade --install` |
| `hls` | `helm list` |
| `hdel` | `helm uninstall` |
| `ans` | `ansible-playbook` |
| `vup` | `vagrant up` |
| `vsh` | `vagrant ssh` |
| `vhalt` | `vagrant halt` |

---

## npm / yarn / pnpm (30 commands)

| Command | What it does |
|---------|-------------|
| `ni` | `npm install` |
| `nid` | `npm install --save-dev` |
| `nig` | `npm install -g` |
| `nrd` | `npm run dev` |
| `nrb` | `npm run build` |
| `nrs` | `npm run start` |
| `nrt` | `npm run test` |
| `nrl` | `npm run lint` |
| `nls` | `npm list --depth=0` |
| `nout` | `npm outdated` |
| `nup` | `npm update` |
| `naf` | `npm audit fix` |
| `ncc` | `npm cache clean --force` |
| `ninit` | `npm init -y` |
| `nx` | `npx` |
| `yi` | `yarn install` |
| `ya` | `yarn add` |
| `yad` | `yarn add --dev` |
| `yrd` | `yarn dev` |
| `yrb` | `yarn build` |
| `yrs` | `yarn start` |
| `yrt` | `yarn test` |
| `yga` | `yarn global add` |
| `pi` | `pnpm install` |
| `pad` | `pnpm add` |
| `padd` | `pnpm add -D` |
| `prd` | `pnpm dev` |
| `prb` | `pnpm build` |
| `prs` | `pnpm start` |
| `prt` | `pnpm test` |

---

## Python / pip / venv (20 commands)

| Command | What it does |
|---------|-------------|
| `py` | `python3` |
| `py2` | `python2` |
| `pip3i` | `pip3 install` |
| `pipr` | `pip3 install -r requirements.txt` |
| `pipf` | `pip3 freeze > requirements.txt` |
| `pipl` | `pip3 list` |
| `pipo` | `pip3 list --outdated` |
| `pipu` | `pip3 install --upgrade` |
| `pipun` | `pip3 uninstall` |
| `venv` | `python3 -m venv venv` |
| `va` | `source venv/bin/activate` |
| `vd` | `deactivate` |
| `pt` | `pytest` |
| `ptv` | `pytest -v` |
| `ptc` | `pytest --cov` |
| `pym` | `python3 -m MODULE` |
| `ipy` | `ipython` |
| `jnb` | `jupyter notebook` |
| `jlab` | `jupyter lab` |
| `pide` | `pip3 install -e .` |

---

## systemd / Services (15 commands)

| Command | What it does |
|---------|-------------|
| `scs` | `sudo systemctl status` |
| `scstart` | `sudo systemctl start` |
| `scstop` | `sudo systemctl stop` |
| `screstart` | `sudo systemctl restart` |
| `scenable` | `sudo systemctl enable` |
| `scdisable` | `sudo systemctl disable` |
| `screload` | `sudo systemctl reload` |
| `scdaemon` | `sudo systemctl daemon-reload` |
| `jctl` | `sudo journalctl -f` |
| `jctlu` | `sudo journalctl -u UNIT` |
| `jctlt` | `sudo journalctl --since today` |
| `scls` | `systemctl list-units --type=service` |
| `scfail` | `systemctl --failed` |
| `scactive` | `systemctl is-active` |
| `scenabled` | `systemctl is-enabled` |

---

## Networking (20 commands)

| Command | What it does |
|---------|-------------|
| `curlt` | `curl` with DNS/connect/TLS timing breakdown |
| `curlh` | `curl -I` -- show HTTP headers |
| `curlj URL DATA` | `curl -X POST` with JSON body |
| `wgetm` | `wget --mirror` -- mirror a site |
| `myip` | Show public IP (`curl ifconfig.me`) |
| `localip` | Show local IP address |
| `ping5` | `ping -c 5` |
| `digs` | `dig +short` -- quick DNS lookup |
| `digr` | `dig -x` -- reverse DNS |
| `nsl` | `nslookup` |
| `trace` | `traceroute` |
| `nstat` | `netstat -tlnp` -- listening ports |
| `ssl` | `ss -tlnp` -- listening ports |
| `conns` | `ss -s` -- connection summary |
| `portcheck HOST PORT` | Check if a port is open (via `nc`) |
| `speedtest` | Internet speed test |
| `ifls` | List network interfaces |
| `headers` | `curl -sI` -- HTTP headers for URL |
| `dlf` | `curl -L -O` -- download file |
| `whois` | Whois lookup |

---

## Redis (12 commands)

| Command | What it does |
|---------|-------------|
| `rd` | `redis-cli` |
| `rdping` | `redis-cli ping` |
| `rdinfo` | `redis-cli info` |
| `rdmon` | `redis-cli monitor` |
| `rdkeys` | `redis-cli keys "*"` |
| `rdget` | `redis-cli get KEY` |
| `rdset` | `redis-cli set KEY VAL` |
| `rddel` | `redis-cli del KEY` |
| `rdflush` | `redis-cli flushdb` |
| `rdflushall` | `redis-cli flushall` |
| `rdsize` | `redis-cli dbsize` |
| `rdshut` | `redis-cli shutdown` |

---

## PostgreSQL (15 commands)

| Command | What it does |
|---------|-------------|
| `pg` | `psql` |
| `pgsu` | `sudo -u postgres psql` |
| `pgls` | `psql -l` -- list databases |
| `pgdb DB [user]` | Connect to a database |
| `pgdump` | `pg_dump` |
| `pgrestore` | `pg_restore` |
| `pgcreate` | `createdb` |
| `pgdrop` | `dropdb` |
| `pgroles` | List PostgreSQL roles |
| `pgconn` | Show active connections |
| `pgsize` | Show table sizes |
| `pgrunning` | Show running queries |
| `pgvacuum` | Run `VACUUM FULL` |
| `pgstatus` | PostgreSQL service status |
| `pgver` | `psql --version` |

---

## nginx (11 commands)

| Command | What it does |
|---------|-------------|
| `ngt` | `nginx -t` -- test config |
| `ngr` | `nginx -s reload` |
| `ngstart` | Start nginx |
| `ngstop` | Stop nginx |
| `ngrestart` | Restart nginx |
| `ngstatus` | nginx service status |
| `ngedit` | Edit `/etc/nginx/nginx.conf` |
| `ngacc` | Tail nginx access log |
| `ngerr` | Tail nginx error log |
| `ngsites` | List sites-enabled |
| `ngconf` | Dump full nginx config |

---

## Cybersecurity / Network Recon (40 commands)

| Command | What it does |
|---------|-------------|
| **Telnet / Netstat** | |
| `tn` | `telnet HOST` |
| `tnp HOST PORT` | Telnet to host:port |
| `nsa` | `netstat -an` -- all connections |
| `nstcp` | `netstat -tlnp` -- listening TCP |
| `nsudp` | `netstat -ulnp` -- listening UDP |
| `nsproc` | `netstat -tulnp` -- with process info |
| `nsest` | Netstat established connections |
| **Nmap** | |
| `nquick` | `nmap -F` -- quick scan (top 100 ports) |
| `nfull` | `nmap -p-` -- full TCP port scan |
| `nsvc` | `nmap -sV` -- service version detection |
| `nos` | `nmap -O` -- OS detection (root) |
| `nagg` | `nmap -A` -- aggressive scan |
| `nsyn` | `nmap -sS` -- stealth SYN scan (root) |
| `nudp` | `nmap -sU` -- UDP scan (root) |
| `nsweep` | `nmap -sn` -- ping sweep subnet |
| `nvuln` | `nmap --script vuln` -- vulnerability scan |
| `nports HOST PORTS` | Scan specific ports |
| `nscript` | `nmap -sC` -- scan with default scripts |
| `nmapxml HOST [file]` | Nmap with XML output |
| **Netcat** | |
| `ncl PORT` | `nc -lvp` -- listen on port |
| `ncs HOST PORT` | `nc` -- connect to host:port |
| `ncscan HOST RANGE` | Port scan with netcat (no nmap needed) |
| **SSL/TLS** | |
| `sslcheck DOMAIN` | Check SSL certificate dates/subject/issuer |
| `sslchain DOMAIN` | Show full SSL certificate chain |
| `sslciphers DOMAIN` | Enumerate SSL ciphers |
| **Recon** | |
| `bannergrab HOST PORT` | Banner grab via netcat |
| `myports` | Show open ports on this host |
| `arptable` | Show ARP table |
| `routes` | Show routing table |
| `fwrules` | Show firewall rules (iptables/pf) |
| **Packet Capture** | |
| `sniff` | `tcpdump -i any` (root) |
| `tcapt IFACE [file]` | Capture packets to pcap file |
| `tcport PORT` | tcpdump filter by port |
| `tchost HOST` | tcpdump filter by host |
| **Security Checks** | |
| `secheaders URL` | Check HTTP security headers |
| `hashpw PASSWORD` | Hash password with SHA-512 |
| `genpw [length]` | Generate random password (default 32) |
| `worldwrite` | Find world-writable files |
| `findsuid` | Find SUID binaries |
| `whoson` | Show logged-in users |

---

## Misc CLI Tools (22 commands)

| Command | What it does |
|---------|-------------|
| `duh` | `du -sh * \| sort -rh` -- disk usage sorted |
| `dfh` | `df -h` -- disk free |
| `fmem` | `free -h` -- memory usage |
| `cpuinfo` | CPU information |
| `w2` | `watch -n 2` -- watch command every 2s |
| `lsofp` | `lsof -c PROCESS` |
| `killname` | `pkill -f NAME` |
| `hist` | Last 50 history entries |
| `cl` | `clear` |
| `reload` | Reload shell config |
| `erc` | Edit shell RC file |
| `path` | Show `$PATH` (one per line) |
| `cx` | `chmod +x FILE` |
| `epoch` | Print Unix timestamp |
| `isodate` | Print ISO 8601 timestamp |
| `uuid` | Generate UUID |
| `b64e` | Base64 encode |
| `b64d` | Base64 decode |
| `sha256` | SHA256 hash of file |
| `md5sum` | MD5 hash of file |

---

## Shell & File Utilities

| Command | What it does |
|---------|-------------|
| `h term` | Grep shell history |
| `hl term` | History "I'm feeling lucky" -- run penultimate match |
| `dst` | Remove all `.DS_Store` files recursively |
| `dust-kash` | Remove all `.kash` cache files recursively |
| `cruft` | Find files larger than 1G from root, sorted by size |
| `date-file-maker` | Create a UTC-timestamped `.txt` file |
| `swap f1 f2` | Swap the names of two files |
| `mkcd dir` | `mkdir -p` + `cd` in one step |
| `extract archive` | Universal extractor (tar/gz/zip/7z/rar) |
| `tre [path]` | `tree` with `.git`/`node_modules` ignored |
| `ports` | Show listening TCP ports |
| `sizeof path` | Human-readable size of file or dir |
| `blk file.py` | Run Python Black formatter |
| `serve [port]` | Quick HTTP server (default port 8000) |
| `jql file.json` | Pretty-print JSON through `jq` + `less` |
| `rmdstore` | Remove `.DS_Store` files with feedback |
| `rmnodemodules` | Interactively remove `node_modules` dirs |
| `countext` | Count files by extension |
| `findlarge [size]` | Find files larger than N (default 10M) |

---

## Python Utilities

### kash
A Python decorator for caching function results to `.kash` files (JSON).

```python
from kash import kash

@kash("my_cache")
def expensive_function(x, y):
    return x ** y

expensive_function(2, 10)  # computes and caches
expensive_function(2, 10)  # returns cached result
```

Cache key uses `int`, `str`, and `float` args only. Clear cache with `dust-kash`.

### autosave-git-recursively.py
Walks child directories, finds all `.git` repos, auto-commits and pushes each.

```bash
python3 autosave-git-recursively.py
```

### repoinspector.py
Fetches open issues across a GitHub user's repos. Requires `requests`.

```bash
python3 repoinspector.py [username]
```

### add_mit_license.py
Adds MIT LICENSE (with croc-shades ASCII art) to all of a user's GitHub repos.

```bash
python3 add_mit_license.py [--dry-run]
```

### rename_recursively.py
Recursively renames files to their last 5 characters. **Destructive**.

```bash
python3 rename_recursively.py /path/to/dir
```

---

## Full Command Reference

Run `gg-help` for the complete reference table with all 380+ commands:

```bash
gg-help             # show everything
gg-help docker      # filter to docker commands
gg-help kubernetes  # filter to k8s commands
gg-help aws         # filter to AWS commands
gg-help terraform   # filter to terraform commands
gg-help npm         # filter to npm/yarn/pnpm
gg-help python      # filter to python/pip
gg-help systemd     # filter to systemd/services
gg-help redis       # filter to redis
gg-help postgres    # filter to postgresql
gg-help nginx       # filter to nginx
gg-help nmap        # filter to nmap/security
gg-help ssl         # filter to SSL/TLS
gg-help tcpdump     # filter to packet capture
```

---

## License
See [LICENSE](LICENSE) file for details.
