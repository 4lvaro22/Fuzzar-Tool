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

execute_web_app(){
    npm start -s &
    printf "\n$blue_color[+]$grey_color Tiene disponible la app web en $cyan_color\e]8;;http://localhost:3000\ahttp://localhost:3000\e]8;;\a$grey_color."
    echo -ne "\n$cyan_color[!]$grey_color Aviso: Las pruebas realizadas por terminal no crean perfiles fuzzers, para ello utilice la versión por app web.\n"
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
    data_source_list=("OBD-II" "CAN Bus" "No predeterminada")
    compilers=("AFLPlusPlus + afl-clang-lto/afl-clang-lto++" "AFLPlusPlus + afl-clang-fast/afl-clang-fast++" "AFLPlusPlus + afl-gcc-fast/afl-g++-fast" "AFLPlusPlus + afl-gcc/afl-g++" "AFLPlusPlus + afl-clang/afl-clang++")
    analysis_desc=("Estándar: sigue una exploración de errores estándar." "ASAN: direcciones de memoria." "MSAN: lecturas de memoria no inicializadas." "UBSAN: comportamientos no definidos." "CFISAN: flujos de control ilegales" "TSAN: hilos de ejecución vulnerables.")
    analysis_comm=("" "AFL_USE_ASAN" "AFL_USE_MSAN" "AFL_USE_UBSAN" "AFL_USE_CFISAN" "AFL_USE_TSAN")
    analysis=("" "ASAN" "MSAN" "UBSAN" "CFISAN" "TSAN")
    fuzzers=("aflplusplus" "honggfuzz")
}


main() {
    original_path=$(pwd)

    while true; do
        echo -e "\n$blue_color[+]$grey_color Selecciona si quieres una recolección de datos predeterminada."
        counter=1
        for el_source_list in "${data_source_list[@]}"; do
            echo "$counter) $el_source_list"
            counter=$((counter+1))
        done
        echo -ne "\n$yellow_color[?]$grey_color Selecciona una opción: " && read reply_data_source_list
        
        if [[ "$reply_build_system" -gt "$counter" ]]; then
            echo -e "\n$red_color[-]$reset_color Opcion no encontrada." 
        else
            data_source=${data_source_list[$reply_data_source_list-1]}
            break
        fi
    done

    echo -ne "\n$yellow_color[?]$grey_color Introduce el directorio de errores del análisis: "
    read errors_directory

    echo -ne "$yellow_color[?]$grey_color Introduce el directorio raíz del simulador o fichero: "
    read path_simulator

    echo -ne "$yellow_color[?]$grey_color Introduce la configuración del compilador deseada: "
    read config_compilator

    echo -ne "$yellow_color[?]$grey_color Introduce la configuración del fuzzing deseada: "
    read config_fuzzing

    echo -ne "$yellow_color[?]$grey_color Introduce la descripción deseada de la prueba: "
    read description
 
    name="Terminal"
    
    echo -ne "\n$blue_color[+]$grey_color Ejecutando análisis..."
    echo -ne "\n$blue_color[+]$grey_color Esto puede durar varios minutos!"
    bash ./webapp.sh "$data_source" "$path_simulator" "$config_compilator" "$config_fuzzing" "$errors_directory" "$description" "$name"

    echo -ne "\n$yellow_color[?]$grey_color Quiere realizar otra prueba fuzzing? (s/N): "
    read loop
    if  [ "$loop" == "S" ] || [ "$loop" == "s" ]; then 
        clear
        cat tool_logo.txt
        main
    fi

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

while getopts "hvs --" option; do
   case $option in
    h)
        help
        exit;;
    s)
        echo -en "$(jq length database/data.json) análisis guardados.\n"
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

execute_web_app
initialize_variables

main