#!/bin/bash
set -e
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

TARGET=$1
TOOLCHAIN=$2

if [ -z "$TARGET" ]; then
    TARGET="CM4-FP"
fi

if [ -z "$TOOLCHAIN" ]; then
    TOOLCHAIN="GCC"
fi

for pack in $(ls ./pack/*.pack); do
    echo "Installing pack: ${pack}"
    cpackget add ${pack} -a
done

if [ "$TOOLCHAIN" == "GCC" ] || [ "$TOOLCHAIN" == "CLANG" ]; then
BIN=./build/${TARGET}/${TOOLCHAIN}/speed/inferencing/outdir/${TARGET}_inferencing.elf
elif [ "$TOOLCHAIN" == "AC6" ]; then
BIN=./build/${TARGET}/${TOOLCHAIN}/speed/inferencing/outdir/${TARGET}_inferencing.axf
else
    echo "Invalid toolchain: ${TOOLCHAIN}"
    exit 1
fi

MODEL_CONFIG_TXT=./Target/${TARGET}/model_config.txt

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
        FVP_MPS2_Cortex-M0 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM0plus" ]; then
        FVP_MPS2_Cortex-M0plus -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM3" ]; then
        FVP_MPS2_Cortex-M3 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM4" ]; then
        FVP_MPS2_Cortex-M4 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM4-FP" ]; then
        FVP_MPS2_Cortex-M4 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM7" ]; then
        FVP_MPS2_Cortex-M7 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM33" ]; then
        FVP_MPS2_Cortex-M33 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM55" ]; then
        FVP_Corstone_SSE-300 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM55-U55-128" ]; then
        FVP_Corstone_SSE-300_Ethos-U55 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM55-U55-256" ]; then
        FVP_Corstone_SSE-300_Ethos-U55 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM55-U65" ]; then
        echo "Ethos-U65 not supported yet"
        #FVP_Corstone_SSE-300_Ethos-U65 -f ./Target/CM55-U65/model_config.txt ./build/CM55/GCC/speed/inferencing/outdir/CM55_inferencing.elf
    elif [ "$TARGET" == "CM85" ]; then
        echo "Test with FVP_MPS2_Cortex-M85"
        FVP_MPS2_Cortex-M85 -f ${MODEL_CONFIG_TXT} ${BIN}
        #echo "Test with FVP_Corstone_SSE-310"
        #FVP_Corstone_SSE-310 -f ./Target/CM85/model_config.txt ./build/CM85/GCC/speed/inferencing/outdir/CM85_inferencing.elf
    elif [ "$TARGET" == "CM85-U65" ]; then
        echo "Ethos-U65 not supported yet"
        #FVP_Corstone_SSE-310_Ethos-U65 -f ./Target/CM85/model_config.txt ./build/CM85/GCC/speed/inferencing/outdir/CM85_inferencing.elf
    else
        echo "No AVH available for ${TARGET}"
    fi
fi
