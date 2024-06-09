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

# Installing function AFLPlusPlus
install_aflplusplus() {
    echo -ne "\n$blue_color[+]$grey_color Installing dependencies..."

    sudo apt-get install -y build-essential python3-dev automake cmake git flex bison libglib2.0-dev libpixman-1-dev python3-setuptools cargo libgtk-3-dev
    sudo apt-get install -y lld-14 llvm-14 llvm-14-dev clang-14 || sudo apt-get install -y lld llvm llvm-dev clang
    sudo apt-get install -y gcc-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-plugin-dev libstdc++-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-dev
    sudo apt-get install -y ninja-build 

    echo -ne "\n$green_color[✓]$grey_color Dependencies done."

    echo -ne "\n$blue_color[+]$grey_color Compiling AFL++..."
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    git clone https://github.com/AFLplusplus/AFLplusplus.git
    cd AFLplusplus
    echo -ne "\n$green_color[✓]$grey_color Compiling completed."

    echo -ne "\n$blue_color[+]$grey_color Installing AFL++..."
    make all
    sudo make install
    
    cd /
    rm -rf "$TEMP_DIR"
    echo -ne "\n$green_color[✓]$grey_color AFL++ installation completed."
}

# Installing function Honggfuzz
install_honggfuzz() {
    echo -ne "\n$blue_color[+]$grey_color Installing dependencies..." 

    sudo apt-get install binutils-dev libunwind-dev libblocksruntime-dev clang
    echo -ne "\n$green_color[✓]$grey_color Dependencies done."

    echo -ne "\n$blue_color[+]$grey_color Compiling Honggfuzz..."
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    git clone https://github.com/google/honggfuzz.git
    cd honggfuzz
    echo -ne "\n$green_color[✓]$grey_color Compiling completed."
    
    echo -ne "\n$blue_color[+]$grey_color Installing Honggfuzz..."
    make
    sudo make install
    
    cd /
    rm -rf "$TEMP_DIR"
    echo -ne "$green_color[✓]$grey_color Honggfuzz installation completed."
}

# Installing function clang
install_libfuzzer() {

    echo -ne "\n$blue_color[+]$grey_color Installing LibFuzzer..."

    sudo apt-get install clang

    echo -ne "\n$green_color[✓]$grey_color LibFuzzer installation completed."
}

sudo apt-get update
sudo apt install python3-pip

if [ $# -eq 0 ]; then
    echo -ne "No arguments provided. Please specify which fuzzers to install."
    echo -ne "Usage: $0 <fuzzers_names_or_all_to_complete_installation>"
    exit 1
fi



for arg in "$@"; do
    case $arg in
        all)
            install_aflplusplus
            install_honggfuzz
            install_libfuzzer
            exit;;
        aflplusplus)
            install_aflplusplus
            ;;
        honggfuzz)
            install_honggfuzz
            ;;
        libfuzzer)
            install_libfuzzer
            ;;
        *)
            echo -ne "Invalid option: $arg"
            echo -ne "Usage: $0 <fuzzers_names_or_all_to_complete_installation>"
            exit 1
            ;;
    esac
done