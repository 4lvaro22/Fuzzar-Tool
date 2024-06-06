#!/bin/bash

# Installing function AFLPlusPlus
install_aflplusplus() {
    echo "[+] Installing dependencies..."

    apt-get install -y build-essential python3-dev automake cmake git flex bison libglib2.0-dev libpixman-1-dev python3-setuptools cargo libgtk-3-dev > /dev/null 2>&1
    apt-get install -y lld-14 llvm-14 llvm-14-dev clang-14 || apt-get install -y lld llvm llvm-dev clang > /dev/null 2>&1
    apt-get install -y gcc-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-plugin-dev libstdc++-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-dev > /dev/null 2>&1
    apt-get install -y ninja-build > /dev/null 2>&1
    echo "[✓] Dependencies done."

    echo "[+] Compiling AFL++..."
    TEMP_DIR=$(mktemp -d) > /dev/null 2>&1
    cd "$TEMP_DIR" > /dev/null 2>&1
    
    git clone https://github.com/AFLplusplus/AFLplusplus.git > /dev/null 2>&1
    cd AFLplusplus
    echo "[✓] Compiling completed." > /dev/null 2>&1

    echo "[+] Installing AFL++..."
    make all > /dev/null 2>&1
    make install > /dev/null 2>&1
    
    cd /
    rm -rf "$TEMP_DIR" > /dev/null 2>&1
    echo "[✓] AFL++ installation completed."
}

# Installing function Honggfuzz
install_honggfuzz() {
    echo "[+] Installing dependencies..." 
    echo "[✓] Dependencies done."

    apt-get install binutils-dev libunwind-dev libblocksruntime-dev clang > /dev/null 2>&1

    echo "[+] Compiling Honggfuzz..."
    TEMP_DIR=$(mktemp -d) > /dev/null 2>&1
    cd "$TEMP_DIR" > /dev/null 2>&1
    
    git clone https://github.com/google/honggfuzz.git
    cd honggfuzz
    echo "[✓] Compiling completed."
    
    echo "[+] Installing Honggfuzz..."
    make > /dev/null 2>&1
    make install > /dev/null 2>&1
    
    cd /
    rm -rf "$TEMP_DIR" > /dev/null 2>&1
    echo "[✓] Honggfuzz installation completed."
}

# Installing function AFLPlusPlus
install_libfuzzer() {

    echo "[+] Installing LibFuzzer..."

    apt-get install clang-6.0 > /dev/null 2>&1
     
    echo "[✓] installation completed."
}

if [ $# -eq 0 ]; then
    echo "No arguments provided. Please specify which fuzzers to install."
    echo "Usage: $0 <fuzzers_names_or_all_to_complete_installation>"
    exit 1
fi

for arg in "$@"; do
    case $arg in
        all)
            install_aflplusplus
            install_honggfuzz
            exit;;
        aflplusplus)
            install_aflplusplus
            ;;
        honggfuzz)
            install_honggfuzz
            ;;
        libfuzzer)
            install_honggfuzz
            ;;
        *)
            echo "Invalid option: $arg"
            echo "Usage: $0 <fuzzers_names_or_all_to_complete_installation>"
            exit 1
            ;;
    esac
done

if [ -f "database/data.json" ]
then
   touch database/data.json;
   chmod 777 database/data.json;
fi

if [ -f "database/profiles.json" ]
then
   touch database/profiles.json;
   chmod 777 database/profiles.json;
fi
