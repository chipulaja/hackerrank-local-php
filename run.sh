#!/bin/bash
set -e
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

if [ -z $1 ]; then
    echo "file php not found. clue : run directory/run.php"; 
elif [ ! -f $1 ]; then
    echo "file $1 not found"; 
else
    clear;
    PROJECT_DIR="$(cd "$(dirname "$1")"; pwd)";
    CASE_INPUT="$PROJECT_DIR/case_input/*";
    CASE_OUTPUT="$PROJECT_DIR/case_output";
    mkdir -p "$PROJECT_DIR/temp/";
    
    for INPUT in $CASE_INPUT; do
        FILENAME="$(basename -- $INPUT)";
        OUTPUT="$PROJECT_DIR/temp/$FILENAME";
        TEST="$CASE_OUTPUT/$FILENAME";
        cat $INPUT | OUTPUT_PATH="$OUTPUT" php $1;
        truncate -s -1 $OUTPUT;
        if cmp -s "$TEST" "$OUTPUT"; then
            echo -e ${grn}$FILENAME success.${grn}${end};
        else
            echo -e ${red}$FILENAME failed.${red}${end};
            diff $TEST $OUTPUT
        fi
    done
fi
