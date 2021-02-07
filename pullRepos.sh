#!bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "$dir/repos"

repos="$(find -maxdepth 1 -type d | sed -n '1!p')" 

while IFS= read -r repo; do
    cd "$repo"
    git pull
    cd ..
done <<< "$repos"
