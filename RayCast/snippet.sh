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
pane_id=$(/Applications/WezTerm.app/Contents/MacOS/wezterm cli spawn)
echo "exec bash ${TOOL_DIR}/../main/snippet.sh" | /Applications/WezTerm.app/Contents/MacOS/wezterm cli send-text --pane-id $pane_id --no-paste
open /Applications/WezTerm.app/
