#!/bin/bash
set -e

cd /

if [ $(uname -m) = "x86_64" ]; then
    wget https://artifacts.tools.arm.com/avh/11.26.11/avh-linux-x86_11.26_11_Linux64.tgz -nv
    tar -xvf avh-linux-x86_11.26_11_Linux64.tgz
    rm -f avh-linux-x86_11.26_11_Linux64.tgz
    mkdir /avh-fvp-linux
    ln -s /avh-linux-x86/* /avh-fvp-linux/
    # rm /avh-fvp-11.24.24/avh-linux-x86/bin/models/libpython3.9.so.1.0
else
    wget https://artifacts.tools.arm.com/avh/11.26.11/avh-linux-aarch64_11.26_11_Linux64_armv8l.tgz -nv
    tar -xvf avh-linux-aarch64_11.26_11_Linux64_armv8l.tgz
    rm -f avh-linux-aarch64_11.26_11_Linux64_armv8l.tgz
    mkdir /avh-fvp-linux
    ln -s /avh-linux-aarch64/* /avh-fvp-linux/
    # rm /avh-fvp-11.24.24/avh-linux-aarch64/bin/models/libpython3.9.so.1.0
fi
