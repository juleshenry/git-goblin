#!/bin/bash
# ============================================================================
# Module: Meta
# Description: Ghee shortcuts and utilities for Meta.
# ============================================================================

# Meta

_GG_REGISTRY["G"]="G [cmd] or G -a 'cmd' 'desc' ||| Ghee hot-doc shell"]
_GG_REGISTRY["gg-help"]="print reference table ||| Full command reference"]

G() {
    local script_dir="$(dirname "${BASH_SOURCE[0]}")"
    if [ -f "$script_dir/ghee-venv/bin/python" ]; then
        "$script_dir/ghee-venv/bin/python" "$script_dir/ghee.py" "$@"
    else
        python3 "$script_dir/ghee.py" "$@"
    fi
}

# ── gg-help: print formatted reference table ──
gg-help() {
    local section="$1"
    echo -e "${_gg_bold}${_gg_magenta}  ghee command reference${_gg_reset}"
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

