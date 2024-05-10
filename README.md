# Edge Impulse Example: stand-alone inferencing for CMSIS toolbox
Example standalone inferecing for AVH created for CMSIS toolbox v2.3.0

## Prerequisites
To add your model to your component library you need to use the cpackget utility:
```sh
cpackget add <your_model>.pack
```
Then you ned to add it to the solution and the project.

### Solution
In [App.clayer.yml](inferencing.csolution.yml), substitute
\# - pack: EdgeImpulse::project_name@version
with
- pack: EdgeImpulse::project_name@version

### Project
In [App.clayer.yml](inferencing.cproject.yml), substitute
\# - component: EdgeImpulse::EdgeImpulse:model:project_name
with
- component: EdgeImpulse::EdgeImpulse:model:project_name

## Build the firmware

### Using command line
The basic compilation command is:
```sh
cbuild inferencing.csolution.yml
```
This command will build for every target and avery configuration available.

To specify a configuration and target (ie speed for CM55):
```sh
cbuild inferencing.csolution.yml --context inferencing.speed+CM55
```

Other useful arguments are:
```
--update-rte
```
Update the RTE directory and files

```
--packs
```
Download missing software packs with cpackget

```
--clean
```
Remove intermediate and output directories

Check the [CMSIS-Toolbox User Guide](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/README.md) for a complete overview of the cbuild command.

### Using CMSIS toolbox extension
In the CMSIS view, click on the hammer icon.

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

## Note
Tested using GCC 10.3.1, GCC 12.3.1, GCC 13.2.1, Arm Compiler v6.19 and 6.22 and Arm LLVM v17.1.
Doesn't work with GCC 12.2.1 for MCU with Helium (Cortex-M55, Cortex-M85).
