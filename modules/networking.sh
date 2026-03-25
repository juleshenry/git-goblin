#!/bin/bash
# Networking

_GG_REGISTRY["curlt"]="curl with timing breakdown ||| curl with DNS/connect/TLS timing"]
_GG_REGISTRY["curlh"]="curl -I URL ||| Show HTTP response headers"]
_GG_REGISTRY["curlj"]="curl -X POST -H JSON -d DATA URL ||| curl POST with JSON body"]
_GG_REGISTRY["wgetm"]="wget --mirror URL ||| Mirror/download entire site"]
_GG_REGISTRY["myip"]="curl ifconfig.me ||| Show public IP address"]
_GG_REGISTRY["localip"]="ipconfig getifaddr en0 ||| Show local IP address"]
_GG_REGISTRY["ping5"]="ping -c 5 HOST ||| Ping with 5 packets"]
_GG_REGISTRY["digs"]="dig +short DOMAIN ||| Quick DNS lookup"]
_GG_REGISTRY["digr"]="dig -x IP ||| Reverse DNS lookup"]
_GG_REGISTRY["nsl"]="nslookup DOMAIN ||| nslookup shortcut"]
_GG_REGISTRY["trace"]="traceroute HOST ||| Traceroute to host"]
_GG_REGISTRY["nstat"]="netstat -tlnp ||| Show listening ports (netstat)"]
_GG_REGISTRY["ssl"]="ss -tlnp ||| Show listening ports (ss)"]
_GG_REGISTRY["conns"]="ss -s ||| Show connection summary"]
_GG_REGISTRY["portcheck"]="nc -zv HOST PORT ||| Check if a port is open"]
_GG_REGISTRY["speedtest"]="speedtest-cli via python ||| Internet speed test"]
_GG_REGISTRY["ifls"]="ifconfig / ip addr show ||| List network interfaces"]
_GG_REGISTRY["headers"]="curl -sI URL ||| Show HTTP headers for URL"]
_GG_REGISTRY["dlf"]="curl -L -O --progress-bar URL ||| Download file with progress"]

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

