#!/usr/bin/env bash
set -euo pipefail

# WezTermで直接プロセス起動した場合zshrcが読まれない
PATH="$PATH:/opt/homebrew/bin"
PATH="$PATH:$HOME/.local/share/mise/installs/node/latest/bin"

readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
bash "$TOOL_DIR/snippet.sh"

