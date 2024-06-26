readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
readonly SNIPPET_DIR="${HOME}/.local/share/snippet"

temp_dir=$(mktemp -dt "snippet-XXXXXXXX")

grep -Sr '^' "$SNIPPET_DIR" | \
    sed -e '/:###/!s%^[^:]\+:%%' -e '/:###/s%^.*/\([^/]\+\)\.md:###%### \1% ' \
    > $temp_dir/snippet

grep -Srn '^###' "$SNIPPET_DIR" | \
    sed 's/:###.*$//' | \
    sed 's/:/ /' \
    > $temp_dir/path-line

grep -hn '^###' "$temp_dir/snippet" | \
    grep -o '^\d\+' | \
    cat -n \
    > $temp_dir/index

selected=$(sed -n 's/### \(.*\)/\1/p' "$temp_dir/snippet" | \
    fzf \
    --reverse \
    --bind 'enter:become:echo enter; echo {n};' \
    --bind 'alt-enter:become:echo alt-enter; echo {n};' \
    --bind 'alt-e:become:echo alt-e; echo {n};' \
    --preview "${TOOL_DIR}/preview.sh \"$temp_dir/snippet\" ${temp_dir} \$(echo {n})" \
    --preview-window "wrap:down:70%" \
)
if [[ -n "${selected}" ]]; then
    header="$(head -1 <<< "${selected}")"
    num="$(sed 1d <<< "${selected}" | tr '' '\n')"
    content="$("${TOOL_DIR}/get_code.sh" "$temp_dir/snippet" ${temp_dir} $num)"
    if [[ "${header}" = "alt-enter" ]]; then
        echo "${content}" > "$temp_dir/selected"
        $EDITOR "$temp_dir/selected"
        if [[ -s "$temp_dir/selected" ]]; then
            cat "$temp_dir/selected" | perl -pe 'chomp if eof' | pbcopy
        fi
    elif [[ "${header}" = "alt-e" ]]; then
        read path line < <(sed -n "$((${num}+1))p" "$temp_dir/path-line")
        echo "$EDITOR $path +$line" >> /tmp/aaa
        $EDITOR $path +$line
    else
        echo "${content}" | perl -pe 'chomp if eof' | pbcopy
    fi
fi

selected=$("${TOOL_DIR}/get_code.sh" "$temp_dir/snippet" ${temp_dir} $selected_num)

