snippet_file=$1
temp_dir=$2
line_x=$(($3+1))

index=$(cat "$temp_dir/index" | \
    grep "^\s*${line_x}\t" | \
    awk '{print $2}')

cat "${snippet_file}" | \
    awk "NR<=${index} {next} !/^###/ {print} /^###/ {exit}" | \
    awk 'f==1 && /^```/ {exit} f==1 {print} /^```/ {f=1}'


