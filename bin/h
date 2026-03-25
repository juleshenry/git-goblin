#!/bin/bash
# h: grep shell history
# Usage: source this file, then use: h searchterm

h() {
    history | grep "$1"
}

# If script is executed directly (not sourced), call the function
if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    h "$@"
fi
