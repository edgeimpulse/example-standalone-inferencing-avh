FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /app

RUN  apt-get update && apt-get install -y wget sudo software-properties-common build-essential && rm -rf /var/lib/apt/lists/*

ADD ./tools/armclang_install.sh /armclang_install.sh
RUN chmod +x /armclang_install.sh && /armclang_install.sh
ENV PATH="/ArmCompilerforEmbedded6.20/bin:${PATH}"
ENV AC6_TOOLCHAIN_6_20_1="/ArmCompilerforEmbedded6.20/bin:"

COPY ./tools/avh-fvp_install.sh /avh-fvp_install.sh
RUN chmod +x /avh-fvp_install.sh && /bin/bash /avh-fvp_install.sh && rm /avh-fvp_install.sh
ENV PATH="/avh-fvp-linux/bin:${PATH}"

#COPY ./tools/armllvm_install.sh /armllvm_install.sh
#RUN chmod +x /armllvm_install.sh && /armllvm_install.sh && rm /armllvm_install.sh
#ENV CLANG_TOOLCHAIN_19_1_1="/LLVMEmbeddedToolchainForArm-19.1.1/bin"
#ENV PATH="/LLVMEmbeddedToolchainForArm-19.1.1/bin:${PATH}"

COPY ./tools/armgcc_install.sh /armgcc_install.sh
RUN chmod +x /armgcc_install.sh && /bin/bash /armgcc_install.sh && rm /armgcc_install.sh
ENV GCC_TOOLCHAIN_13_2_1="/arm-gnu-toolchain-13.3.rel1-arm-none-eabi/bin"
ENV PATH="/arm-gnu-toolchain-13.3.rel1-arm-none-eabi/bin:${PATH}"

COPY ./tools/cmsistoolbox_install.sh /cmsistoolbox_install.sh
RUN chmod +x /cmsistoolbox_install.sh && /bin/bash /cmsistoolbox_install.sh && rm /cmsistoolbox_install.sh
ENV CMSIS_COMPILER_ROOT="/cmsis-toolbox-linux/etc"
ENV CMSIS_PACK_ROOT=/cmsis-packs
ENV PATH="/cmsis-toolbox-linux/bin:/ninja/:/cmake/bin/:${PATH}"

RUN cpackget init https://www.keil.com/pack/index.pidx

RUN cpackget update-index
COPY ./pack/cmsis_packages.cpinstall /cmsis_packages.cpinstall
RUN cpackget add -a -f /cmsis_packages.cpinstall && rm /cmsis_packages.cpinstall
RUN cpackget add Keil::V2M-MPS2_CMx_BSP@1.8.2
RUN cpackget add Keil::V2M-MPS2_IOTKit_BSP@1.5.2

# license handling
ADD arm_mlops_docker_license* /

RUN if [ -f /arm_mlops_docker_license ]; then \
    armlm import --file /arm_mlops_docker_license; \
    else \
    armlm activate -product KEMDK-COM0 -server https://mdk-preview.keil.arm.com; \
    fi
