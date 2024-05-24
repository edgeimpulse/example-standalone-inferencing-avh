#!/bin/bash
set -e

cd /
if [ $(uname -m) = "x86_64" ]; then
    wget https://artifacts.tools.arm.com/arm-none-eabi-gcc/13.2.1/arm-gnu-toolchain-x86_64-arm-none-eabi.tar.bz2 -nv
    tar xjf arm-gnu-toolchain-x86_64-arm-none-eabi.tar.bz2
    rm -f arm-gnu-toolchain-x86_64-arm-none-eabi.tar.bz2
    echo 'GCC_TOOLCHAIN_13_2_1=/arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/bin' >> ~/.bashrc
    echo 'export PATH=arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/bin:$PATH' >> ~/.bashrc
else
    wget https://artifacts.tools.arm.com/arm-none-eabi-gcc/13.2.1/arm-gnu-toolchain-aarch64-arm-none-eabi.tar.bz2 -nv
    tar xjf arm-gnu-toolchain-aarch64-arm-none-eabi.tar.bz2
    rm -f arm-gnu-toolchain-aarch64-arm-none-eabi.tar.bz2
    echo 'GCC_TOOLCHAIN_13_2_1=/arm-gnu-toolchain-13.2.Rel1-aarch64-arm-none-eabi/bin' >> ~/.bashrc
    echo 'export PATH=/arm-gnu-toolchain-13.2.Rel1-aarch64-arm-none-eabi/bin:$PATH' >> ~/.bashrc
fi
