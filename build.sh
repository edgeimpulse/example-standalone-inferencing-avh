#!/bin/bash
set -e
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

POSITIONAL_ARGS=()

run_avh () {
    if [ ! -f ${BIN} ]; then
        echo "Binary not found: ${BIN}"
        exit 1
    fi

    if [ "$TARGET" == "CM0" ]; then
        FVP_MPS2_Cortex-M0 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM0plus" ]; then
        FVP_MPS2_Cortex-M0plus -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM3" ]; then
        FVP_MPS2_Cortex-M3 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM4" ] || [ "$TARGET" == "CM4-FP" ]; then
        FVP_MPS2_Cortex-M4 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM7-SP" ] || [ "$TARGET" == "CM7-DP" ]; then
        FVP_MPS2_Cortex-M7 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM33" ] || [ "$TARGET" == "CM33-FP" ]; then
        FVP_MPS2_Cortex-M33 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM55" ]; then
        FVP_MPS2_Cortex -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM55-U55-128" ]; then
        FVP_Corstone_SSE-300_Ethos-U55 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM55-U55-256" ]; then
        FVP_Corstone_SSE-300_Ethos-U55 -f ${MODEL_CONFIG_TXT} ${BIN}
    elif [ "$TARGET" == "CM55-U65" ]; then
        echo "Ethos-U65 not supported yet"
        #FVP_Corstone_SSE-300_Ethos-U65 -f ./Target/CM55-U65/model_config.txt ./build/CM55/GCC/${BUILD_CONFIG}/inferencing/outdir/CM55_inferencing.elf
    elif [ "$TARGET" == "CM85" ]; then
        echo "Test with FVP_MPS2_Cortex-M85"
        FVP_MPS2_Cortex-M85 -f ${MODEL_CONFIG_TXT} ${BIN}
        #echo "Test with FVP_Corstone_SSE-310"
        #FVP_Corstone_SSE-310 -f ./Target/CM85/model_config.txt ./build/CM85/GCC/${BUILD_CONFIG}/inferencing/outdir/CM85_inferencing.elf
    elif [ "$TARGET" == "CM85-U65" ]; then
        echo "Ethos-U65 not supported yet"
        #FVP_Corstone_SSE-310_Ethos-U65 -f ./Target/CM85/model_config.txt ./build/CM85/GCC/${BUILD_CONFIG}/inferencing/outdir/CM85_inferencing.elf
    else
        echo "No AVH available for ${TARGET}"
        exit 1
    fi
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --target)
            TARGET="$2"
            shift # past argument
            shift # past value
            ;;
        --config)
            BUILD_CONFIG="$2"
            shift # past argument
            shift # past value
            ;;
        --toolchain)
            TOOLCHAIN="$2"
            shift # past argument
            shift # past value
            ;;
        --run)
            RUN=1
            shift # past value
            ;;
        --clean)
            CLEAN=1
            shift # past argument
            ;;
        *)
            POSITIONAL_ARGS+=("$1") # save positional arg
            shift # past argument
            ;;
    esac
done

# default values
if [ -z "$TARGET" ]; then
    TARGET="CM4-FP"
fi

if [ -z "$BUILD_CONFIG" ]; then
    BUILD_CONFIG="Speed"
fi

if [ -z "$TOOLCHAIN" ]; then
    TOOLCHAIN="GCC"
fi

for pack in $(ls ./pack/*.pack); do
    echo "Installing pack: ${pack}"
    cpackget add ${pack} -a
done

if [ "$TOOLCHAIN" == "GCC" ] || [ "$TOOLCHAIN" == "CLANG" ]; then
BIN=./build/${TARGET}/${TOOLCHAIN}/${BUILD_CONFIG}/inferencing/outdir/${TARGET}_inferencing.elf
elif [ "$TOOLCHAIN" == "AC6" ]; then
BIN=./build/${TARGET}/${TOOLCHAIN}/${BUILD_CONFIG}/inferencing/outdir/${TARGET}_inferencing.axf
else
    echo "Invalid toolchain: ${TOOLCHAIN}"
    exit 1
fi

MODEL_CONFIG_TXT=./Target/${TARGET}/model_config.txt

cpackget update-index

if [ "$CLEAN" == 1 ]; then
    echo "Cleaning build"
    rm -rf ./build
    rm -rf ./RTE
    rm -rf ./tmp
    rm -f inference.cbuild-idx.yml
    rm -f inference.cbuild-pack.yml
    rm -f inference.cbuild-set.yml
    exit 0
elif [ "$RUN" == 1 ]; then
    run_avh
    exit 0
else
    echo "Cleaning before building..."
    echo "Building firmware for ${TARGET} using ${TOOLCHAIN} toolchain"
    cbuild ./inferencing.csolution.yml --context-set --update-rte --packs --context inferencing.${BUILD_CONFIG}+${TARGET} --toolchain ${TOOLCHAIN}
    run_avh
    exit 0
fi
