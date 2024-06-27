snippet_dir=$1
global_path_line_file=$2

grep -Srn '^' "$snippet_dir" | \
    awk '/^(.*):### / {p=$1} {print p}' | \
    sed 's/:\([^:]\+\):.*$/ \1/' \
    > "$global_path_line_file"
