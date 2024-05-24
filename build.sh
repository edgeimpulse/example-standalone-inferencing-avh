#!/bin/bash
set -e
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

TARGET=$1
TOOLCHAIN=$2

if [ -z "$TARGET" ]; then
    TARGET="CM4"
fi

if [ -z "$TOOLCHAIN" ]; then
    TOOLCHAIN="GCC"
fi

if [ "$TARGET" == "clean" ]; then
    echo "Cleaning build"
    cbuild ./inferencing.csolution.yml --context-set --update-rte --packs --context inferencing -C
    exit 0
else
    echo "Building firmware for ${TARGET} using ${TOOLCHAIN} toolchain"
    cbuild ./inferencing.csolution.yml --context-set --update-rte --packs --context inferencing.speed+${TARGET} --toolchain ${TOOLCHAIN}
fi
