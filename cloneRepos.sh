#!/bin/bash

# python command for processing json 
pythonCommand="import sys, json
for element in json.load(sys.stdin):
    print(element['full_name'])
"

if [ "$1" == "" ]; then
    printf 'GitHub Username Required\n'
    exit
fi 

# ensure user wants to clone
printf 'Clone All Public Repos for '$1' (y/n): '
read answer

if [ ${answer^} == "Y" ]; then
    #cd to repos directory
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    cd $DIR
    mkdir -p repos
    cd repos

    # curls github api, pipes into python script to process json, prepends https://github.com/ to each repo name, runs git clone on all
    curl -s "Accept: application/vnd.github.v3+json" https://api.github.com/users/$1/repos \
    | python3 -c "$pythonCommand" \
    | while read line; do echo 'https://github.com/'$line; done \
    | while read line; do git clone $line; done
fi