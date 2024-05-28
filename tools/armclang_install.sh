#!/bin/bash
set -e

cd /

if [ $(uname -m) = "x86_64" ]; then 
    export ARCH=x86_64; 
else export ARCH=armv8l_64 ; 
fi

wget https://artifacts.tools.arm.com/arm-compiler/6.20/21/standalone-linux-${ARCH}-rel.tgz -nv
mkdir ./ArmCompilerforEmbedded6.20
tar xvfz ./standalone-linux-${ARCH}-rel.tgz  -C ./ArmCompilerforEmbedded6.20
