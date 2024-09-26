readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
readonly SNIPPET_DIR="${HOME}/.local/share/snippet"

export EDITOR="nvim"

function fzf_select_num() {
    sed -n 's/### \(.*\)/\1/p' "$tmpdir/snippet" | \
        fzf \
        --reverse \
        --bind 'enter:become:echo enter {n}' \
        --bind 'alt-enter:become:echo alt-enter {n}' \
        --bind 'alt-e:become:echo alt-e {n}' \
        --bind "alt-a:reload:\"$TOOL_DIR/temporary.sh\" save_global_path_line \"$SNIPPET_DIR\" $tmpdir; cat \"$tmpdir/snippet\"" \
        --preview "\"${TOOL_DIR}/preview.sh\" $tmpdir {n}" \
        --preview-window "wrap:down:70%"
}


tmpdir=$(mktemp -dt 'ClipboardHistory.XXXXXXXX')

"$TOOL_DIR/temporary.sh" save_snippet "$SNIPPET_DIR" $tmpdir
"$TOOL_DIR/temporary.sh" save_path_line "$SNIPPET_DIR" $tmpdir
"$TOOL_DIR/temporary.sh" save_index "$SNIPPET_DIR" $tmpdir

selected_num=$(fzf_select_num)

if [[ -n "${selected_num}" ]]; then
    read header num <<< "${selected_num}"
    if [[ "${header}" = "alt-enter" ]]; then
        "${TOOL_DIR}/get_code.sh" $tmpdir $num > "$tmpdir/code"
        "${EDITOR-vim}" "$tmpdir/code"
        if [[ -s "$tmpdir/code" ]]; then
            cat "$tmpdir/code" | perl -pe 'chomp if eof' | pbcopy
        fi
    elif [[ "${header}" = "alt-e" ]]; then
        if [[ -s "$tmpdir/global_path_line" ]]; then
            read path line < <(sed -n "$((${num}+1))p" "$tmpdir/global_path_line")
        else
            read path line < <(sed -n "$((${num}+1))p" "$tmpdir/path_line")
        fi
        "${EDITOR-vim}" "$path" "+$line"
    else
        "${TOOL_DIR}/get_code.sh" $tmpdir $num | \
        perl -pe 'chomp if eof' | pbcopy
    fi
fi

