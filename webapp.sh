reset_all_env_variables () {
    for env_variables in "${analysis_comm}"; do
        unset $env_variables
    done
}

web_scrapping(){
    if  [ "$1" == "obd" ] ; then 
        python3 script/web/web_scrapper.py
    elif [ "$1" == "can" ] ; then 
        echo "can"
    else
        echo "NO"
    fi
}

compiling_simulator () {
    if [[ -d "$1" ]] ; then
        cd $1;
        $2
    elif
        cd dirname $1
        $2
    else
        exit -1
    fi
}

analysis_comm=("" "AFL_USE_ASAN" "AFL_USE_MSAN" "AFL_USE_UBSAN" "AFL_USE_CFISAN" "AFL_USE_TSAN")
reset_all_env_variables

web_scrapping $1

compiling_simulator $2 $3

$4

python3 script/data_modifier.py $1 $2 $3 $4 $5



