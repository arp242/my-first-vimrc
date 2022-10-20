#!/bin/sh

set -euC
root="$(dirname "$(readlink -f "$0")")"
cd "$root"

if [ -f ./node_modules/coffeescript/bin/coffee ]; then
	./node_modules/coffeescript/bin/coffee -c ./*.coffee
else
	coffee -c ./*.coffee
fi

# https://github.com/Carpetsmoker/singlepage
singlepage page.html >| index.html || cat index.html
