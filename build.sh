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

for pack in $(ls ./pack/*.pack); do
    echo "Installing pack: ${pack}"
    cpackget add ${pack} -a
done

if [ "$TARGET" == "clean" ]; then
    echo "Cleaning build"
    cbuild ./inferencing.csolution.yml --context-set --update-rte --packs --context inferencing -C
    exit 0
else
    echo "Cleaning before building..."
    rm -rf ./build
    rm -rf ./RTE
    rm -f inferencing.cbuild-idx.yml
    rm -f inferencing.cbuild-pack.yml
    rm -f inferencing.cbuild-set.yml
    echo "Building firmware for ${TARGET} using ${TOOLCHAIN} toolchain"
    cbuild ./inferencing.csolution.yml --context-set --update-rte --packs --context inferencing.speed+${TARGET} --toolchain ${TOOLCHAIN}
fi
