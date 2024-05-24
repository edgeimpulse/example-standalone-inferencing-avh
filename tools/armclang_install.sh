#!/bin/bash
set -e

cd /

wget https://artifacts.tools.arm.com/arm-compiler/6.20/21/standalone-linux-${ARCH}-rel.tgz -nv
mkdir ./ArmCompilerforEmbedded6.20
tar xvfz ./standalone-linux-${ARCH}-rel.tgz -C ./ArmCompilerforEmbedded6.20
chown -R arm_mlops_docker ./ArmCompilerforEmbedded6.20
