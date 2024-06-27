snippet_file=$1
index_file=$2
num=$(($3+1))

index=$(sed -n "${num}p" "$index_file")

cat "${snippet_file}" | \
    awk "NR==${index} {print} NR<=${index} {next} !/^###/ {print} /^###/ {exit}" | \
    mdcat
