readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
readonly SNIPPET_FILE="${HOME}/.local/share/zinit/plugins/cm-hirano-shigetoshi---snippet/snippet"

temp_dir=$(mktemp -dt "XXXXXXXX")
mkdir -p "$temp_dir"
grep -hn '^###' "$SNIPPET_FILE" | \
    grep -o '^\d\+' | \
    cat -n \
    > $temp_dir/index

selected=$(sed -n 's/### \(.*\)/\1/p' "$SNIPPET_FILE" | \
    fzf \
    --reverse \
    --bind 'enter:become:echo enter; echo {n};' \
    --bind 'alt-enter:become:echo alt-enter; echo {n};' \
    --preview "${TOOL_DIR}/preview.sh \"$SNIPPET_FILE\" ${temp_dir} \$(echo {n})" \
    --preview-window "wrap:down:50%" \
)
if [[ -n "${selected}" ]]; then
    header="$(head -1 <<< "${selected}")"
    num="$(sed 1d <<< "${selected}" | tr '' '\n')"
    content="$("${TOOL_DIR}/get_code.sh" "$SNIPPET_FILE" ${temp_dir} $num)"
    if [[ "${header}" = "alt-enter" ]]; then
        echo "${content}" > "$temp_dir/selected"
        $EDITOR "$temp_dir/selected"
        if [[ -s "$temp_dir/selected" ]]; then
            cat "$temp_dir/selected" | perl -pe 'chomp if eof' | pbcopy
        fi
    else
        echo "${content}" | perl -pe 'chomp if eof' | pbcopy
    fi
fi

selected=$("${TOOL_DIR}/get_code.sh" "$SNIPPET_FILE" ${temp_dir} $selected_num)

