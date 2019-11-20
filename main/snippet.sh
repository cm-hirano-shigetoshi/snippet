function fzf_snippet() {
  export PATH="${HOME}/local/bin:${PATH}"
  local readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
  local readonly SNIPPET_DIR="${TOOL_DIR}/../snippets/$1"
  local result
  result=$(fzfyml run ${TOOL_DIR}/snippet.yml "$SNIPPET_DIR")
  echo "${result}" >> ~/.debug
  if [[ -z "${result}" ]]; then
    return
  fi
  local type
  type=$(head -1 <<< "${result}")
  if [[ "${type}" = "clipboard" ]]; then
    sed '1d' <<< "${result}" \
      | tr '' '\n' \
      | perl ${TOOL_DIR}/del_newline.pl \
      | pbcopy
  elif [[ "${type}" = "edit" ]]; then
    local temp_file
    temp_file=$(mktemp "/tmp/snippet.XXXXXX")
    sed '1d' <<< "${result}" \
      | tr '' '\n' \
      | perl ${TOOL_DIR}/del_newline.pl \
      > ${temp_file}
    ${EDITOR-vim} ${temp_file}
    if [[ -s ${temp_file} ]]; then
      cat ${temp_file} | pbcopy
    fi
  elif [[ "${type}" = "edit_original" ]]; then
    target_file=$(sed '1d' <<< "${result}" | awk -F ':' '{print $1}')
    line_x=$(sed '1d' <<< "${result}" | awk -F ':' '{print $3}')
    ${EDITOR-vim} +${line_x} -c "normal zz" ${target_file}
  fi
}
fzf_snippet "$@"

