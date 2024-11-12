#!/bin/bash
set -e

cd /

apt install -y libtinfo5

if [ $(uname -m) = "x86_64" ]; then
    wget https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-19.1.1/LLVM-ET-Arm-19.1.1-Windows-x86_64.zip -nv
    tar -xf  LLVM-ET-Arm-19.1.1-Linux-x86_64.tar.xz 
    rm -f  LLVM-ET-Arm-19.1.1-Linux-x86_64.tar.xz 
    mkdir /LLVMEmbeddedToolchainForArm-19.1.1
    ln -s /LLVM-ET-Arm-19.1.1-Linux-x86_64/* /LLVMEmbeddedToolchainForArm-19.9.1/
else
    wget https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-19.1.1/LLVM-ET-Arm-19.1.1-Linux-AArch64.tar.xz -nv
    tar -xf LLVM-ET-Arm-19.1.1-Linux-AArch64.tar.xz
    rm -f LLVM-ET-Arm-19.1.1-Linux-AArch64.tar.xz
    mkdir /LLVMEmbeddedToolchainForArm-19.1.1
    ln -s /LLVM-ET-Arm-19.1.1-Linux-AArch64/* /LLVMEmbeddedToolchainForArm-19.1.1/
fi
