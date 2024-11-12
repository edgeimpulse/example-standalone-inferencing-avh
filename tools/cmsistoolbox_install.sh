#!/bin/bash
set -e

cd /

if [ $(uname -m) = "x86_64" ]; then
    wget https://artifacts.tools.arm.com/cmsis-toolbox/2.6.1/cmsis-toolbox-linux-amd64.tar.gz -nv
    tar -xf cmsis-toolbox-linux-amd64.tar.gz
    rm -f cmsis-toolbox-linux-amd64.tar.gz
    mkdir /cmsis-toolbox-linux
    ln -s /cmsis-toolbox-linux-amd64/* /cmsis-toolbox-linux/

    wget https://github.com/Kitware/CMake/releases/download/v3.29.3/cmake-3.29.3-linux-x86_64.sh -nv
    mkdir /cmake
    sh cmake-3.29.3-linux-x86_64.sh --prefix=/cmake --skip-license
    ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
else
    wget https://artifacts.tools.arm.com/cmsis-toolbox/2.6.1/cmsis-toolbox-linux-arm64.tar.gz -nv    
    tar -xf cmsis-toolbox-linux-arm64.tar.gz
    rm -f cmsis-toolbox-linux-arm64.tar.gz
    mkdir /cmsis-toolbox-linux
    ln -s /cmsis-toolbox-linux-arm64/* /cmsis-toolbox-linux/

    wget https://github.com/Kitware/CMake/releases/download/v3.29.3/cmake-3.29.3-linux-aarch64.sh -nv
    mkdir /cmake
    sh cmake-3.29.3-linux-aarch64.sh --prefix=/cmake --skip-license
    rm ./cmake-3.29.3-linux-aarch64.sh    
fi

mkdir /ninja
if [ $(uname -m) = "x86_64" ]; then
    wget -qO /ninja/ninja.gz https://github.com/ninja-build/ninja/releases/latest/download/ninja-linux.zip -nv
else
    wget -qO /ninja/ninja.gz https://github.com/ninja-build/ninja/releases/latest/download/ninja-linux-aarch64.zip
fi

gunzip /ninja/ninja.gz
chmod a+x /ninja/ninja
