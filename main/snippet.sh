readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
readonly SNIPPET_DIR="${HOME}/.local/share/snippet"

readonly temp_dir=$(mktemp -dt "snippet-XXXXXXXX")


function fzf_select_num() {
    sed -n 's/### \(.*\)/\1/p' "$temp_dir/snippet" | \
        fzf \
        --reverse \
        --bind 'enter:become:echo enter {n}' \
        --bind 'alt-enter:become:echo alt-enter {n}' \
        --bind 'alt-e:become:echo alt-e {n}' \
        --bind "alt-a:reload:\"$TOOL_DIR/func\" save_global_path_line \"$SNIPPET_DIR\" $temp_dir; cat \"$temp_dir/snippet\"" \
        --preview "\"${TOOL_DIR}/preview.sh\" $temp_dir {n}" \
        --preview-window "wrap:down:70%"
}


"$TOOL_DIR/func" save_snippet "$SNIPPET_DIR" $temp_dir
"$TOOL_DIR/func" save_path_line "$SNIPPET_DIR" $temp_dir
"$TOOL_DIR/func" save_index "$SNIPPET_DIR" $temp_dir

selected_num=$(fzf_select_num)

if [[ -n "${selected_num}" ]]; then
    read header num <<< "${selected_num}"
    if [[ "${header}" = "alt-enter" ]]; then
        "${TOOL_DIR}/get_code.sh" $temp_dir $num > "$temp_dir/code"
        $EDITOR "$temp_dir/code"
        if [[ -s "$temp_dir/code" ]]; then
            cat "$temp_dir/code" | perl -pe 'chomp if eof' | pbcopy
        fi
    elif [[ "${header}" = "alt-e" ]]; then
        if [[ -s "$temp_dir/global_path_line" ]]; then
            read path line < <(sed -n "$((${num}+1))p" "$temp_dir/global_path_line")
        else
            read path line < <(sed -n "$((${num}+1))p" "$temp_dir/path_line")
        fi
        $EDITOR $path +$line
    else
        "${TOOL_DIR}/get_code.sh" $temp_dir $num | \
        perl -pe 'chomp if eof' | pbcopy
    fi
fi
