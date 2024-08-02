#!/bin/bash
set -e

cd /

apt install -y libtinfo5

if [ $(uname -m) = "x86_64" ]; then
    wget https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-17.0.1/LLVMEmbeddedToolchainForArm-17.0.1-Linux-x86_64.tar.xz  -nv
    tar -xf LLVMEmbeddedToolchainForArm-17.0.1-Linux-x86_64.tar.xz
    rm -f LLVMEmbeddedToolchainForArm-17.0.1-Linux-x86_64.tar.xz
    mkdir /LLVMEmbeddedToolchainForArm-17.0.1
    ln -s /LLVMEmbeddedToolchainForArm-17.0.1-Linux-x86_64/* /LLVMEmbeddedToolchainForArm-17.0.1/
else
    wget https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-17.0.1/LLVMEmbeddedToolchainForArm-17.0.1-Linux-AArch64.tar.xz -nv
    tar -xf LLVMEmbeddedToolchainForArm-17.0.1-Linux-AArch64.tar.xz
    rm -f LLVMEmbeddedToolchainForArm-17.0.1-Linux-AArch64.tar.xz
    mkdir /LLVMEmbeddedToolchainForArm-17.0.1
    ln -s /LLVMEmbeddedToolchainForArm-17.0.1-Linux-AArch64/* /LLVMEmbeddedToolchainForArm-17.0.1/
fi
