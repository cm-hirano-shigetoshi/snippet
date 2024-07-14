#!/usr/bin/env bash
set -euo pipefail

"${EDITOR-vim}" "$1"
if [[ -s "$1" ]]; then
    cat "$1" | perl -pe 'chomp if eof' | pbcopy
fi
