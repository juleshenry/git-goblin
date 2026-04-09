#!/bin/bash
# ============================================================================
# Module: Macos Power Tools
# Description: Ghee shortcuts and utilities for Macos Power Tools.
# ============================================================================

# macOS Power Tools

_GG_REGISTRY["caffeinate"]="caffeinate -d ||| Prevent Mac from sleeping"
_GG_REGISTRY["hidefiles"]="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder ||| Hide hidden files in Finder"
_GG_REGISTRY["showfiles"]="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder ||| Show hidden files in Finder"
_GG_REGISTRY["flushui"]="killall Dock; killall Finder ||| Restart Dock and Finder to fix UI glitches"
_GG_REGISTRY["copyurl"]="osascript -e 'tell app \"Safari\" to get URL of front document' | pbcopy ||| Copy URL of active Safari tab"
_GG_REGISTRY["copycwd"]="pwd | tr -d '\n' | pbcopy ||| Copy current directory path to clipboard"
_GG_REGISTRY["locks"]="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend ||| Lock mac screen immediately"
_GG_REGISTRY["emptytrash"]="rm -rf ~/.Trash/* ||| Empty the Trash immediately"

alias caffeinate='caffeinate -d'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias flushui='killall Dock; killall Finder'
alias copyurl='osascript -e "tell app \"Safari\" to get URL of front document" | pbcopy; echo "Safari URL copied to clipboard!"'
alias copycwd='pwd | tr -d "\n" | pbcopy; echo "Copied $(pwd) to clipboard!"'
alias locks='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend 2>/dev/null || pmset displaysleepnow'
alias emptytrash='rm -rf ~/.Trash/*; echo "Trash emptied."'
