#!/bin/bash
set -e

cd /

apt install -y libtinfo5

if [ $(uname -m) = "x86_64" ]; then
    wget https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-17.0.1/LLVMEmbeddedToolchainForArm-17.0.1-Linux-x86_64.tar.xz  -nv
    tar -xf LLVMEmbeddedToolchainForArm-17.0.1-Linux-x86_64.tar.gz
    rm -f LLVMEmbeddedToolchainForArm-17.0.1-Linux-x86_64.tar.gz
    echo 'CLANG_TOOLCHAIN_17_0_1=/LLVMEmbeddedToolchainForArm-17.0.1x86_64/bin' >> ~/.bashrc
else
    wget https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-17.0.1/LLVMEmbeddedToolchainForArm-17.0.1-Linux-AArch64.tar.xz -nv
    tar -xf LLVMEmbeddedToolchainForArm-17.0.1-Linux-AArch64.tar.xz
    rm -f LLVMEmbeddedToolchainForArm-17.0.1-Linux-AArch64.tar.xz
    echo 'CLANG_TOOLCHAIN_17_0_1=/LLVMEmbeddedToolchainForArm-17.0.1-Linux-AArch64/bin' >> ~/.bashrc
fi
