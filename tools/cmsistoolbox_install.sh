#!/bin/bash
set -e

cd /

if [ $(uname -m) = "x86_64" ]; then
    wget https://artifacts.tools.arm.com/cmsis-toolbox/2.3.0/cmsis-toolbox-linux-amd64.tar.gz -nv
    wget https://github.com/Kitware/CMake/releases/download/v3.29.3/cmake-3.29.3-linux-x86_64.sh -nv
    tar -xf cmsis-toolbox-linux-amd64.tar.gz
    rm -f cmsis-toolbox-linux-amd64.tar.gz
    chmod +x cmake-3.29.3-linux-x86_64.sh
    mkdir /cmake
    ./cmake-3.29.3-linux-x86_64.sh --skip-license --prefix=/cmake
else
    wget https://artifacts.tools.arm.com/cmsis-toolbox/2.3.0/cmsis-toolbox-linux-arm64.tar.gz -nv
    wget https://github.com/Kitware/CMake/releases/download/v3.29.3/cmake-3.29.3-linux-aarch64.sh -nv
    tar -xf cmsis-toolbox-linux-arm64.tar.gz
    rm -f cmsis-toolbox-linux-arm64.tar.gz
    chmod +x cmake-3.29.3-linux-aarch64.sh
    mkdir /cmake
    ./cmake-3.29.3-linux-aarch64.sh --skip-license --prefix=/cmake
fi

mkdir /ninja
wget -qO /ninja/ninja.gz https://github.com/ninja-build/ninja/releases/latest/download/ninja-linux.zip -nv
gunzip /ninja/ninja.gz 
chmod a+x /ninja/ninja 

echo 'export PATH=/cmake/bin:/ninja/:$PATH' >> ~/.bashrc
echo 'CMSIS_PACK_ROOT="/packs"' >> ~/.bashrc

if [ $(uname -m) = "x86_64" ]; then
    echo 'export PATH=/cmsis-toolbox-linux-amd64/bin:$PATH' >> ~/.bashrc
    echo 'CMSIS_COMPILER_ROOT=/cmsis-toolbox-linux-amd64/etc' >> ~/.bashrc
    /cmsis-toolbox-linux-amd64/bin/cpackget init https://www.keil.com/pack/index.pidx
else
    echo 'export PATH=/cmsis-toolbox-linux-arm64/bin:$PATH' >> ~/.bashrc
    echo 'CMSIS_COMPILER_ROOT=/cmsis-toolbox-linux-arm64/etc' >> ~/.bashrc
    /cmsis-toolbox-linux-arm64/bin/cpackget init https://www.keil.com/pack/index.pidx
fi
