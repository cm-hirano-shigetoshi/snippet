readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
readonly SNIPPET_DIR="${HOME}/.local/share/snippet"

readonly temp_dir=$(mktemp -dt "snippet-XXXXXXXX")

function save_snippet() {
    grep -Sr '^' "$SNIPPET_DIR" | \
        sed -e '/:###/!s%^[^:]\+:%%' -e '/:###/s%^.*/\([^/]\+\)\.md:###%### \1% ' \
        > $temp_dir/snippet
}

function save_path_line() {
    grep -Srn '^###' "$SNIPPET_DIR" | \
        sed 's/:###.*$//' | \
        sed 's/:/ /' \
        > $temp_dir/path-line
}

function save_index() {
    grep -hn '^###' "$temp_dir/snippet" | \
        grep -o '^\d\+' \
        > $temp_dir/index
}

function fzf_select_num() {
    sed -n 's/### \(.*\)/\1/p' "$temp_dir/snippet" | \
        fzf \
        --reverse \
        --bind 'enter:become:echo enter {n}' \
        --bind 'alt-enter:become:echo alt-enter {n}' \
        --bind 'alt-e:become:echo alt-e {n}' \
        --preview "${TOOL_DIR}/preview.sh \"$temp_dir/snippet\" \"$temp_dir/index\" \$(echo {n})" \
        --preview-window "wrap:down:70%"
}


save_snippet
save_path_line
save_index

selected_num=$(fzf_select_num)

if [[ -n "${selected_num}" ]]; then
    read header num <<< "${selected_num}"
    if [[ "${header}" = "alt-enter" ]]; then
        "${TOOL_DIR}/get_code.sh" "$temp_dir/snippet" "$temp_dir/index" $num > "$temp_dir/code"
        $EDITOR "$temp_dir/code"
        if [[ -s "$temp_dir/code" ]]; then
            cat "$temp_dir/code" | perl -pe 'chomp if eof' | pbcopy
        fi
    elif [[ "${header}" = "alt-e" ]]; then
        read path line < <(sed -n "$((${num}+1))p" "$temp_dir/path-line")
        $EDITOR $path +$line
    else
        "${TOOL_DIR}/get_code.sh" "$temp_dir/snippet" "$temp_dir/index" $num | \
        perl -pe 'chomp if eof' | pbcopy
    fi
fi
