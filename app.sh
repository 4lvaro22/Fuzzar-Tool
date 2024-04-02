#!/bin/bash

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
    cd; cd /TFG/OBD-II-Fuzzer
    rm -r output/ -f
    afl-fuzz -V 5 -i inputs/ -o output/ -- $1 -t /dev/stdin

}

build_systems=("Configure build system" "CMake build system" "Meson build system")
compilers=("AFLPlusPlus + afl-clang-lto/afl-clang-lto++" "AFLPlusPlus + afl-clang-fast/afl-clang-fast++" "AFLPlusPlus + afl-gcc-fast/afl-g++-fast" "AFLPlusPlus + afl-gcc/afl-g++" "AFLPlusPlus + afl-clang/afl-clang++")

echo -n "Introduce el directorio raíz donde se encuentra la aplicación: "
read path

compiling_simulator

echo -n "Introduce el directorio del archivo binario del simulador: "
read path_sim
execute_fuzzer "${path_sim}"




