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

compiling_simulator () {
    while true; do
        case $reply_build_system in
            1)
            cd "${path}"; CC=afl-gcc-fast CXX=afl-g++-fast ./configure --disable-shared
            ;;

            2)
                cd "${path}"; 
                sudo rm -r build -f; 
                mkdir build; 
                cd build;
                echo -e "$blue_color[+]$grey_color Compilando la aplicación. Esto puede tardar varios minutos...";
                cmake -DCMAKE_C_COMPILER=afl-gcc-fast -DCMAKE_CXX_COMPILER=afl-g++-fast .. > /dev/null 2>&1; 
                echo -e "$green_color[✓]$grey_color Aplicación compilada!!";
                echo -e "$blue_color[+]$grey_color Instalando la aplicación. Esto puede tardar varios minutos...";
                sudo make install > /dev/null 2>&1;
                echo -e "$green_color[✓]$grey_color Aplicación instalada!!";
                echo -e "$blue_color[+]$grey_color Verifica su instalación en el directorio bin de su usuario.";
            ;;

            3)
            cd "${path}"; CC=afl-gcc-fast CXX=afl-g++-fast meson
            ;;
        esac
    
        # Condition to exit the loop
        if [ $? -eq 0 ]; then
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
   echo "-f <nombre_fuzzer>   Seleccionar el fuzzer para los análisis. (Por defecto: AFLPlusPlus)."
   echo "-h                   Muestra una ayuda sobre los argumentos de la herramienta."
   echo "-l                   Muestra los nombres de los fuzzers disponibles."
   echo "-s                   Muestra los análisis guardados en memoria."
   echo "-t <tiempo_minutos>  Establecer el tiempo (en minutos) para cada análisis realizado. (Por defecto: 30 min.)."
   echo "-v                   Muestra la versión del software."
}

fuzzer_list()
{
    fuzzer_counter=0
    echo -e "\nFuzzers disponibles: \n"
    for fuzzer_it in "${fuzzers[@]}"; do
        echo -e "$fuzzer_counter   $fuzzer_it"
        fuzzer_counter=$((fuzzer_counter + 1));
    done
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

while getopts "h f: v t: l s --" option; do
   case $option in
    h)
        help
        exit;;
    l) 
        fuzzer_list
        exit;;
    f)
        fuzzer="$OPTARG"

        bool_cf=0
        for fuzzer_it in "${fuzzers[@]}"; do
            if [[ $fuzzer_it == $fuzzer ]]; then
                bool_cf=1
            fi
        done

        if [[ ! $fuzzer =~ ^[a-z]+$ || "$bool_cf" -eq 0 ]]; then
            echo -ne "\n$red_color[-]$reset_color Error en el valor del fuzzer."
            echo -ne "\n$grey_color[!]$reset_color Si estás ejecutando sudo bash app.sh -ft, prueba a ejecutar $purple_color sudo bash app.sh -f <nombre_fuzzer> -t <tiempo_minutos>$reset_color"
            echo -ne "\n$grey_color[!]$reset_color En otro caso, deberías proporcionar un fuzzer válido. Prueba a ejecutar $purple_color sudo bash app.sh -l$reset_color para ver los fuzzers existentes.\n"
            exit
        fi;;
    s)
        echo -en "$(jq length data.json) análisis guardados.\n"
        exit;;
    t)
        execution_time="$OPTARG"
        if [[ ! "$execution_time" =~ ^[0-9]+$ ]]; then
            echo -ne "\n$red_color[-]$reset_color Error en el valor del tiempo."
            echo -ne "\n$grey_color[!]$grey_color Si estás ejecutando sudo bash app.sh -ft, prueba a ejecutar $purple_color sudo bash app.sh -f <nombre_fuzzer> -t <tiempo_minutos>$reset_color"
            echo -ne "\n$grey_color[!]$grey_color En otro caso, deberías proporcionar un tiempo en minutos válido.\n"
            exit
        fi

        execution_time=$((tiempo * 60));;
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
cat tool_logo.txt

if [[ -d "/results" ]]
then
   mkdir results;
   chmod 777 results;
fi

if [ -f "data.json" ]
then
   touch data.json;
   chmod 777 data.json;
fi

execution_time=1

echo -ne "\n$yellow_color[?]$grey_color Quieres desplegar la visualización de datos mediante una aplicación web? (s/N): "
read app_web

if [ "$app_web" == "s" ] || [ "$app_web" == "S" ]; then 
    execute_web_app
fi

main