#!/bin/bash
set -e

cd /

AVH_VERSION=11.28.32
ANOTHER_AVH_VERSION=11.28_32

if [ $(uname -m) = "x86_64" ]; then
    wget https://artifacts.tools.arm.com/avh/${AVH_VERSION}/avh-linux-x86_${ANOTHER_AVH_VERSION}_Linux64.tgz -nv
    tar -xvf avh-linux-x86_${ANOTHER_AVH_VERSION}_Linux64.tgz
    rm -f avh-linux-x86_${ANOTHER_AVH_VERSION}_Linux64.tgz
    mkdir /avh-fvp-linux
    ln -s /avh-linux-x86/* /avh-fvp-linux/
else
    wget https://artifacts.tools.arm.com/avh/${AVH_VERSION}/avh-linux-aarch64_${ANOTHER_AVH_VERSION}_Linux64_armv8l.tgz -nv
    tar -xvf avh-linux-aarch64_${ANOTHER_AVH_VERSION}_Linux64_armv8l.tgz
    rm -f avh-linux-aarch64_${ANOTHER_AVH_VERSION}_Linux64_armv8l.tgz
    mkdir /avh-fvp-linux
    ln -s /avh-linux-aarch64/* /avh-fvp-linux/
fi
