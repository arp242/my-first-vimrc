#!/bin/sh

set -euC
root="$(dirname "$(readlink -f "$0")")"
cd "$root"

coffee -c ./*.coffee

# https://github.com/Carpetsmoker/singlepage
singlepage page.html >| index.html || cat index.html
