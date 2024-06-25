snippet_file=$1
temp_dir=$2
line_x=$(($3+1))

index=$(cat "$temp_dir/index" | \
    grep "^\s*${line_x}\t" | \
    awk '{print $2}')

cat "${snippet_file}" | \
    awk "NR<=${index} {next} !/^###/ {print} /^###/ {exit}" | \
    bat --color always --plain -l python

