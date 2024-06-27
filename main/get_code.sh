snippet_file=$1
index_file=$2
num=$(($3+1))

global_path_line_file="$(dirname $index_file)/global-path-line"
if [[ -s "$global_path_line_file" ]]; then
    read snippet_file index <<< $(sed -n "${num}p" "$global_path_line_file")
else
    index=$(sed -n "${num}p" "$index_file")
fi

cat "${snippet_file}" | \
    awk "NR<=${index} {next} !/^###/ {print} /^###/ {exit}" | \
    awk 'f==1 && /^```/ {exit} f==1 {print} /^```/ {f=1}'
