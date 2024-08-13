#!/usr/bin/env bash
set -euo pipefail

readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
readonly WEZTERM_APP="/Applications/WezTerm.app"
readonly WEZTERM_APP_DIR="${WEZTERM_APP}/Contents/MacOS"
readonly EDITOR_WAIT_SECOND=3600

function wezterm_run() {
    pane_id=$("${WEZTERM_APP_DIR}/wezterm" cli split-pane -- "$@")
    "${WEZTERM_APP_DIR}/wezterm" cli zoom-pane --pane-id $pane_id
}

function wezterm_run_shell() {
    pane_id=$("${WEZTERM_APP_DIR}/wezterm" cli spawn)
    echo "$@; exit" | "${WEZTERM_APP_DIR}/wezterm" cli send-text --pane-id ${pane_id} --no-paste
}

tmpdir=$(mktemp -dt 'Snippet.XXXXXXXX')
mkfifo "$tmpdir/done"

wezterm_run "${TOOL_DIR}/snippet.sh" "${tmpdir}"
open "${WEZTERM_APP}"

timeout $EDITOR_WAIT_SECOND cat "$tmpdir/done" >/dev/null
if [[ -e "$tmpdir/code" ]]; then
    wezterm_run_shell "${TOOL_DIR}/edit.sh" "$tmpdir/code"
elif [[ -e "$tmpdir/edit_path" ]] && [[ -e "$tmpdir/edit_line" ]] ; then
    wezterm_run_shell "${EDITOR-vim}" "$(cat $tmpdir/edit_path)" "+$(cat $tmpdir/edit_line)"
fi

