# Edge Impulse Example: stand-alone inferencing for CMSIS toolbox
Example standalone inferencing for AVH created for CMSIS toolbox v2.4.0

## Update the model to test
Once you have deployed your model as a Open CMSIS pack, unzip the downloaded file, you will find 2 pack files and a `model.clayer.yml`

To add your model to your component library you need to use the `cpackget` utility:
```sh
cpackget add <your_model>.pack
```

You probably need to install the Edge Impulse sdk too:
```sh
cpackget add EdgeImpulse.EI-SDK.x.yy.zzpack
```

Then you need to move the `model.clayer.yml` into the `model` folder.

## Build the firmware

### Using command line
The most basic compilation command is:
```sh
cbuild inferencing.csolution.yml
```
This command will build for every target and every configuration available, so probably isn't what you are looking for.

To specify a configuration and target (ie speed for CM55):
```sh
cbuild inferencing.csolution.yml --context inferencing.speed+CM55
```

Other useful arguments are:
```sh
--update-rte
```
Update the RTE directory, which contains target specific header.

```sh
--packs
```
Automatically download any missing software packs with cpackget.

```sh
--clean
```

Remove intermediate and output directories

Usually, the most common way to compiler for a specific target and toolchain is:
```sh
cbuild inferencing.csolution.yml --update-rte --packs --context inferencing.speed+CM55 --toolchain GCC
```

Check the [CMSIS-Toolbox User Guide](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/README.md) for a complete overview of the `cbuild` command.

### Using CMSIS toolbox extension
In the CMSIS view, click on the hammer icon.

### Using docker
This repository contains a docker image with the required dependencies for building with gcc and llvm:
```sh
docker build -t standalone-csolution .
```

Copy the content of the deployment for your project in the pack folder.

Build the firmware with the following command:
```sh
docker run --rm -it -v "${PWD}":/app standalone-csolution /bin/bash -c "./build.sh --target <TARGET> --config <BUILD_CONFIG> --toolchain <TOOLCHAIN>"
```

### Using script
You can use the `build.sh` script to compile, target and toolchain can be specified as follow:

```sh
./build.sh --target <TARGET> --config <BUILD_CONFIG> --toolchain <TOOLCHAIN>
```

The script will also install any package present in the `pack` folder.

> [!Note]
> After building, the bin will be run locally on AVH.

## Run on AVH
The basic usage is:
```sh
<AVH FVP for the target> -f <fvp config file> <elf file to be loaded>
```
Some examples:
- Run Test on model for Cortex-M3 (speed) compiled with GCC
```sh
FVP_MPS2_Cortex-M3 -f ./Target/CM3/model_config.txt ./build/CM3/GCC/speed/outdir/CM3_inferencing.elf
```
- Run Test on model for Cortex-M55 with Ethos (none) compiled with Arm Compiler
```sh
FVP_Corstone_SSE-300_Ethos-U55 -f ./Target/CM55/model_config.txt ./build/CM55/AC6/speed/outdir/CM55_inferencing.elf
```

## Available target
CM0
CM0plus
CM3
CM4
CM4-FP
CM7
CM33
CM55
CM55-U128
CM55-U55-128
CM55-U55-128
CM85

## Note
Tested using GCC 10.3.1, GCC 12.3.1, GCC 13.2.1, GCC 13.3.1, Arm Compiler v6.19 and 6.22 and Arm LLVM v17.1.
Doesn't work with GCC 12.2.1 for MCU with Helium (Cortex-M55, Cortex-M85).
