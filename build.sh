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

cpackget update-index

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
    if [ "$TARGET" == "CM0" ]; then
        FVP_MPS2_Cortex-M0 -f ./Target/CM0/model_config.txt ./build/CM0/GCC/speed/inferencing/outdir/CM0_inferencing.elf
    elif [ "$TARGET" == "CM0plus" ]; then
        FVP_MPS2_Cortex-M0plus -f ./Target/CM0plus/model_config.txt ./build/CM0plus/GCC/speed/inferencing/outdir/CM0plus_inferencing.elf
    elif [ "$TARGET" == "CM3" ]; then
        FVP_MPS2_Cortex-M3 -f ./Target/CM3/model_config.txt ./build/CM3/GCC/speed/inferencing/outdir/CM3_inferencing.elf
    elif [ "$TARGET" == "CM4" ]; then
        FVP_MPS2_Cortex-M4 -f ./Target/CM4/model_config.txt ./build/CM4/GCC/speed/inferencing/outdir/CM4_inferencing.elf
    elif [ "$TARGET" == "CM4-FP" ]; then
        FVP_MPS2_Cortex-M4 -f ./Target/CM4-FP/model_config.txt ./build/CM4-FP/GCC/speed/inferencing/outdir/CM4-FP_inferencing.elf
    elif [ "$TARGET" == "CM7" ]; then
        FVP_MPS2_Cortex-M7 -f ./Target/CM7/model_config.txt ./build/CM7/GCC/speed/inferencing/outdir/CM7_inferencing.elf
    elif [ "$TARGET" == "CM33" ]; then
        FVP_MPS2_Cortex-M33 -f ./Target/CM33/model_config.txt ./build/CM33/GCC/speed/inferencing/outdir/CM33_inferencing.elf
    elif [ "$TARGET" == "CM55" ]; then
        #FVP_MPS2_Cortex-M55 -f ./Target/CM55/model_config.txt ./build/CM55/GCC/speed/inferencing/outdir/CM55_inferencing.elf
        FVP_Corstone_SSE-300 -f ./Target/CM55/model_config.txt ./build/CM55/GCC/speed/inferencing/outdir/CM55_inferencing.elf
    elif [ "$TARGET" == "CM55-U55-128" ]; then
        FVP_Corstone_SSE-300_Ethos-U55 -f ./Target/CM55-U55-128/model_config.txt ./build/CM55-U55-128/GCC/speed/inferencing/outdir/CM55-U55-128_inferencing.elf
    elif [ "$TARGET" == "CM55-U55-256" ]; then
        FVP_Corstone_SSE-300_Ethos-U55 -f ./Target/CM55-U55-256/model_config.txt ./build/CM55-U55-256/GCC/speed/inferencing/outdir/CM55-U55-256_inferencing.elf
    elif [ "$TARGET" == "CM55-U65" ]; then
        FVP_Corstone_SSE-300_Ethos-U65 -f ./Target/CM55/model_config.txt ./build/CM55/GCC/speed/inferencing/outdir/CM55_inferencing.elf
    elif [ "$TARGET" == "CM85" ]; then
        #echo "Test with FVP_MPS2_Cortex-M85"
        #FVP_MPS2_Cortex-M85 -f ./Target/CM85/model_config.txt ./build/CM85/GCC/speed/inferencing/outdir/CM85_inferencing.elf
        echo "Test with FVP_Corstone_SSE-310"
        FVP_Corstone_SSE-310 -f ./Target/CM85/model_config.txt ./build/CM85/GCC/speed/inferencing/outdir/CM85_inferencing.elf
    elif [ "$TARGET" == "CM85-U65" ]; then
        FVP_Corstone_SSE-310_Ethos-U65 -f ./Target/CM85/model_config.txt ./build/CM85/GCC/speed/inferencing/outdir/CM85_inferencing.elf
    else
        echo "No AVH available for ${TARGET}"
    fi
fi
