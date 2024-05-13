#!/bin/bash

black_color="\e[0;30m"
red_color="\e[0;31m"
green_color="\e[0;32m"
yellow_color="\e[0;33m"
blue_color="\e[0;34m"
purple_color="\e[0;35m"
cyan_color="\e[0;36m"
grey_color="\e[0;37m"
white_color="\e[0;38m"
reset_color="\e[0;39m"

reset_all_env_variables () {
    for env_variables in "${analysis_comm}"; do
        unset $env_variables
    done
}

ask_build_system () {
    while true; do
        echo -e "\n$blue_color[+]$grey_color Selecciona el system build que usa la aplicación."
        counter=1
        for build_system in "${build_systems[@]}"; do
            echo "$counter) $build_system"
            counter=$((counter+1))
        done
        echo -ne "\n$yellow_color[?]$grey_color Selecciona una opción: " && read reply_build_system
        if [ "$reply_build_system" -gt "$counter" ]; then
            echo -e "\n$red_color[-]$reset_color Opcion no encontrada." 
        else
            break
        fi
    done
}

ask_sanitizer () {
    while true; do
        echo -e "\n$blue_color[+]$grey_color Selecciona la exploración de errores deseada."
        counter=1
        for sanitizer in "${analysis_desc[@]}"; do
            echo "$counter) $sanitizer"
            counter=$((counter+1))
        done
        echo -ne "\n$yellow_color[?]$grey_color Selecciona una opción: " && read reply_sanitizer
        if [ "$reply_sanitizer" -gt "$counter" ] || [ "$reply_sanitizer" -lt "0" ]; then
            echo -e "\n$red_color[-]$reset_color Opcion no encontrada." 
        else
            break
        fi
    done
}


afl() {
    reset_all_env_variables
    ask_sanitizer
    export "${analysis_comm[reply_sanitizer-1]}=1"
    echo -e "$blue_color[+]$grey_color Fuzzer escogido AFLPlusPlus."
    echo -e "$blue_color[+]$grey_color Exploración de errores escogida "${analysis[reply_sanitizer]}"."
    echo -e "$blue_color[+]$grey_color Tiempo estimado "${execution_time}" segundos."
    echo -e "$blue_color[+]$grey_color Ejecutando análisis..."
    current_date=$(date +"%d%m%Y-%H%M%S")
    afl-fuzz -V $execution_time -i inputs/ -o "results/result-"$current_date"" -- $1 -t /dev/stdin > /dev/null 2>&1;
    finilizing_rutine
}

honggfuzz() {
    echo -e "$blue_color[+]$grey_color Fuzzer escogido HonggFuzz."
    echo -e "$blue_color[+]$grey_color La exploración de errores para HonggFuzz es la estándar."
    echo -e "$blue_color[+]$grey_color Tiempo estimado "${execution_time}" segundos."
    echo -e "$blue_color[+]$grey_color Ejecutando análisis..."
    current_date=$(date +"%d%m%Y-%H%M%S")
    honggfuzz -t $execution_time -V -i inputs/ -o "results/result-"$current_date"" -s -- $1 -t /dev/stdin > /dev/null 2>&1;
    finilizing_rutine
}

execute_fuzzer() { 
    cd $original_path;
    if [[ "$fuzzer" == "honggfuzz" ]]; then
        honggfuzz $1
    else
        afl $1
    fi
}

execute_web_app(){
    npm start -s &
    printf "\n$blue_color[+]$grey_color Tiene los datos listos para su visualización en $cyan_color\e]8;;http://localhost:3000\ahttp://localhost:3000\e]8;;\a$grey_color.\n"
}

finilizing_rutine() {
    chmod -R 777 results/*
    echo -e "$green_color[✓]$grey_color Todo ha funcionado correctamente. Tiene los resultados en el directorio output."
    python3 script/data_modifier.py $original_path AFLPlusPlus $execution_time $current_date
    
    echo -ne "\n$yellow_color[?]$grey_color Quiere realizar otra prueba fuzzing? (s/N): "
    read loop
    if  [ "$loop" == "S" ] || [ "$loop" == "s" ]; then 
        clear
        cat tool_logo.txt
        main
    fi
}

help()
{
   echo -e "\nsudo bash app.sh [ opciones ]"
   echo -e "\nopciones:"
   echo "-h                   Muestra una ayuda sobre los argumentos de la herramienta."
   echo "-s                   Muestra los análisis guardados en memoria."
   echo "-v                   Muestra la versión del software."
}

version()
{
   echo -e "\nVersion: 1.0.0"
}

initialize_variables(){
    build_systems=("Configure build system" "CMake build system" "Meson build system")
    compilers=("AFLPlusPlus + afl-clang-lto/afl-clang-lto++" "AFLPlusPlus + afl-clang-fast/afl-clang-fast++" "AFLPlusPlus + afl-gcc-fast/afl-g++-fast" "AFLPlusPlus + afl-gcc/afl-g++" "AFLPlusPlus + afl-clang/afl-clang++")
    analysis_desc=("Estándar: sigue una exploración de errores estándar." "ASAN: direcciones de memoria." "MSAN: lecturas de memoria no inicializadas." "UBSAN: comportamientos no definidos." "CFISAN: flujos de control ilegales" "TSAN: hilos de ejecución vulnerables.")
    analysis_comm=("" "AFL_USE_ASAN" "AFL_USE_MSAN" "AFL_USE_UBSAN" "AFL_USE_CFISAN" "AFL_USE_TSAN")
    analysis=("" "ASAN" "MSAN" "UBSAN" "CFISAN" "TSAN")
    fuzzers=("aflplusplus" "honggfuzz")
}


main() {
    original_path=$(pwd)

    python3 web_scrapper.py

    echo -ne "\n$yellow_color[?]$grey_color Introduce el directorio raíz donde se encuentra la aplicación: "
    read path

    ask_build_system
    compiling_simulator

    echo -ne "\n$yellow_color[?]$grey_color Introduce el directorio del archivo binario del simulador: "
    read path_sim
    
    execute_fuzzer "${path_sim}"
}

cleanup() {
    pkill -P $$
    clear
    exit 0
}

if  [ $(id -u) -ne 0 ]; then 
    echo -e "\n$red_color[-]$reset_color Debes ser usuario root para ejecutar el análisis."
    echo -e "$blue_color[+]$grey_color Prueba ejecutando$purple_color sudo bash $0"
    exit -1
fi

initialize_variables

while getopts "hvs --" option; do
   case $option in
    h)
        help
        exit;;
    s)
        echo -en "$(jq length data.json) análisis guardados.\n"
        exit;;
    v)
        version
        exit;;
    \?) 
        echo -ne "\n$red_color[-]$reset_color Has introducido argumentos no válidos!!\n"
        exit;;
   esac
done

trap 'cleanup' SIGINT SIGTERM
clear
cat banner/logo.asc

if [ -f "data.json" ]
then
   touch data.json;
   chmod 777 data.json;
fi

echo -ne "\n$yellow_color[?]$grey_color Quieres desplegar la visualización de datos mediante una aplicación web? (s/N): "
read app_web

if [ "$app_web" == "s" ] || [ "$app_web" == "S" ]; then 
    execute_web_app
fi

main