#!/bin/bash
# ghee-functions.sh
# Core functionality and interactive shell wrapper for Ghee

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
# GHEE CMD REGISTRY & PYTHON RUNNER
# ============================================================================

declare -A _GG_REGISTRY
_GG_CUSTOM_FILE="${HOME}/.ghee-custom"

if [ -n "$ZSH_VERSION" ]; then
    export _GHEE_DIR="$(dirname "${(%):-%x}")"
elif [ -n "$BASH_VERSION" ]; then
    export _GHEE_DIR="$(dirname "${BASH_SOURCE[0]}")"
else
    export _GHEE_DIR="${PWD}"
fi

g() {
    local script_dir="${_GHEE_DIR}"
    if [ -f "$script_dir/ghee-venv/bin/python" ]; then
        "$script_dir/ghee-venv/bin/python" "$script_dir/ghee.py" "$@"
    elif [ -f "$script_dir/ghee-venv/Scripts/python.exe" ]; then
        "$script_dir/ghee-venv/Scripts/python.exe" "$script_dir/ghee.py" "$@"
    else
        python3 "$script_dir/ghee.py" "$@"
    fi
}
