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



compiling_simulator () {
    echo -e "\n"
    PS3="Qué build system usa la aplicación: "

    select build_system_selected in "${build_systems[@]}"; do
        echo -n "[+] Compilando la aplicación..."
        while true; do
            case $REPLY in
                1)
                cd "${path}"; CC=afl-gcc-fast CXX=afl-g++-fast ./configure --disable-shared
                ;;

                2)
                cd "${path}"; sudo rm -r build -f; mkdir build; cd build; cmake -DCMAKE_C_COMPILER=afl-gcc-fast -DCMAKE_CXX_COMPILER=afl-g++-fast .. > /dev/null 2>&1 ; sudo make install > /dev/null 2>&1
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
        break
    done
}

execute_fuzzer() { 
    cd; cd TFG/OBD-II-Fuzzer/
    rm -r output/ -f
    afl-fuzz -V  -i inputs/ -o output/ -- $1 -t /dev/stdin

}

if  [ $(id -u) -ne 0 ]; then 
    echo -e "\n$red_color[!]$reset_color Debes ser usuario root para ejecutar el análisis."
    echo -e "[+] Prueba ejecutando$purple_color sudo bash $0"
    exit -1
fi

build_systems=("Configure build system" "CMake build system" "Meson build system")
compilers=("AFLPlusPlus + afl-clang-lto/afl-clang-lto++" "AFLPlusPlus + afl-clang-fast/afl-clang-fast++" "AFLPlusPlus + afl-gcc-fast/afl-g++-fast" "AFLPlusPlus + afl-gcc/afl-g++" "AFLPlusPlus + afl-clang/afl-clang++")

echo -n "Introduce el directorio raíz donde se encuentra la aplicación: "
read path

compiling_simulator

echo -n "Introduce el directorio del archivo binario del simulador: "
read path_sim
execute_fuzzer "${path_sim}"