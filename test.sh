#!/bin/bash

if [ -z "$1" ]                # No argument passed?
then
    echo 'no filename provided'
    exit 0
fi


filename_input=${1}
result_dir=${2:-'results'}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

echo $filename_input
echo $result_dir
if [[ ! -e $result_dir ]]; then
    mkdir $result_dir
elif [[ ! -d $result_dir ]]; then
    echo "$result_dir already exists but is not a directory"
else
    echo "$result_dir already exists"
    cd $result_dir
    rm -vr *.html
fi

echo "---[1. running code_to_doc python script]---"
cd ${SCRIPTPATH}
python3.9 code_to_doc/python_docs.py -p $filename_input -o $result_dir

echo "---[2. running importer script]---"
ts-node importer/src/index.ts $result_dir -o $result_dir
