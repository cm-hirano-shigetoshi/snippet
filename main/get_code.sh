#!/usr/bin/env bash
set -eu

temp_dir=$1
num=$(($2+1))


if [[ -s "$temp_dir/global_path_line" ]]; then
    path_line_file="$temp_dir/global_path_line"
else
    path_line_file="$temp_dir/path_line"
fi

read snippet_file index <<< $(sed -n "${num}p" "$path_line_file")
cat "${snippet_file}" | \
    awk "NR<=${index} {next} !/^###/ {print} /^###/ {exit}" | \
    awk 'f==1 && /^```/ {exit} f==1 {print} /^```/ {f=1}'
