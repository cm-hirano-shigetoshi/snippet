#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Snippet
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📋

# Documentation:
# @raycast.description post to slack

readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
export FZF_DEFAULT_OPTS="--exact --no-mouse"
"${TOOL_DIR}/../main/wezterm.sh"
