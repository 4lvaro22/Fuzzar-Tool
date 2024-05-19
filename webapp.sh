#!/bin/bash

reset_all_env_variables(){
    for env_variables in "${analysis_comm}"; do
        unset $env_variables
    done
}

web_scrapping(){
    if [[ -d "inputs" ]] ; then
        rm -rf inputs/*

    if  [ "$1" == "OBD-II" ] ; then 
        python3 script/web/obd_web_scrapper.py
        rm -f inputs/candump_output.txt
    elif [ "$1" == "CAN Bus" ] ; then 
        python3 script/web/canbus_scrapper.py
    fi
}

compiling_simulator() {
    if [[ -d "$1" ]] ; then
        cd "$1";
        rm -rf build
        eval "$(echo "$2")"
        cd "$actual_dir"
    elif [[ -f "$1" ]] ; then
        cd "$(dirname "$1")"
        eval "$(echo "$2")"
    else
        exit -1
    fi
}

executing_fuzzing(){
    echo "$1"
    eval "$(echo "$1")" > /dev/null 2>&1
    chmod -R 777 "$2"
}

web_scrapper="$1"
path_sim="$2"
conf_comp="$3"
conf_fuzz="$4"
dirs_errs="$5"
description="$6"
name="$7"
actual_dir="$(pwd)"

echo "$conf_fuzz"

analysis_comm=("" "AFL_USE_ASAN" "AFL_USE_MSAN" "AFL_USE_UBSAN" "AFL_USE_CFISAN" "AFL_USE_TSAN")
reset_all_env_variables

web_scrapping "$web_scrapper"

compiling_simulator "$path_sim" "$conf_comp"

executing_fuzzing "$conf_fuzz" "$dirs_errs"

cd "$actual_dir"

python3 script/data_modifier.py "$web_scrapper" "$path_sim" "$conf_comp" "$conf_fuzz" "$dirs_errs" "$description" "$name"



