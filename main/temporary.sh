#!/usr/bin/env bash
set -eu

snippet_dir="$2"
temp_dir="$3"


function save_snippet() {
    grep -Sr '^' "$snippet_dir" | \
        sed -e '/:###/!s%^[^:]\+:%%' -e '/:###/s%^.*/\([^/]\+\)\.md:###%### \1% ' \
        > $temp_dir/snippet
}

function save_path_line() {
    grep -Srn '^###' "$snippet_dir" | \
        sed 's/:###.*$//' | \
        sed 's/:/ /' \
        > $temp_dir/path_line
}

function save_index() {
    grep -hn '^###' "$temp_dir/snippet" | \
        grep -o '^\d\+' \
        > $temp_dir/index
}

function save_global_path_line() {
    grep -Srn '^' "$snippet_dir" | \
        awk '/^(.*):### / {p=$1} {print p}' | \
        sed 's/:\([^:]\+\):.*$/ \1/' \
        > "$temp_dir/global_path_line"
}


"$1"
