#!/bin/bash
set -e

cd /
if [ $(uname -m) = "x86_64" ]; then
    wget https://artifacts.tools.arm.com/arm-none-eabi-gcc/13.3.1/arm-gnu-toolchain-x86_64-arm-none-eabi.tar.bz2 -nv
    tar xjf arm-gnu-toolchain-x86_64-arm-none-eabi.tar.bz2
    rm -f arm-gnu-toolchain-x86_64-arm-none-eabi.tar.bz2
    mkdir /arm-gnu-toolchain-13.3.rel1-arm-none-eabi
    ln -s /arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi/* /arm-gnu-toolchain-13.3.rel1-arm-none-eabi/

else
    wget https://artifacts.tools.arm.com/arm-none-eabi-gcc/13.3.1/arm-gnu-toolchain-aarch64-arm-none-eabi.tar.bz2 -nv
    tar xjf arm-gnu-toolchain-aarch64-arm-none-eabi.tar.bz2
    rm -f arm-gnu-toolchain-aarch64-arm-none-eabi.tar.bz2
    mkdir /arm-gnu-toolchain-13.3.rel1-arm-none-eabi
    ln -s /arm-gnu-toolchain-13.3.rel1-aarch64-arm-none-eabi/* /arm-gnu-toolchain-13.3.rel1-arm-none-eabi/
fi
