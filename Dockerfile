FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /app

RUN  apt-get update && apt-get install -y wget sudo software-properties-common && rm -rf /var/lib/apt/lists/*

#ADD ./tools/armclang_install.sh /armclang_install.sh
#RUN chmod +x /armclang_install.sh && /armclang_install.sh

COPY ./tools/vela_install.sh /vela_install.sh
RUN chmod +x /vela_install.sh && /bin/bash /vela_install.sh && rm /vela_install.sh

COPY ./tools/avh-fvp_install.sh /avh-fvp_install.sh
RUN chmod +x /avh-fvp_install.sh && /bin/bash /avh-fvp_install.sh && rm /avh-fvp_install.sh

COPY ./tools/armllvm_install.sh /armllvm_install.sh
RUN chmod +x /armllvm_install.sh && /armllvm_install.sh && rm /armllvm_install.sh
ENV CLANG_TOOLCHAIN_17_0_1="/LLVMEmbeddedToolchainForArm-17.0.1/bin"
ENV PATH="/LLVMEmbeddedToolchainForArm-17.0.1/bin:${PATH}"

COPY ./tools/armgcc_install.sh /armgcc_install.sh
RUN chmod +x /armgcc_install.sh && /bin/bash /armgcc_install.sh && rm /armgcc_install.sh
ENV GCC_TOOLCHAIN_13_2_1="/arm-gnu-toolchain-13.2.Rel1-arm-none-eabi/bin"
ENV PATH="/arm-gnu-toolchain-13.2.Rel1-arm-none-eabi/bin:${PATH}"

COPY ./tools/cmsistoolbox_install.sh /cmsistoolbox_install.sh
RUN chmod +x /cmsistoolbox_install.sh && /bin/bash /cmsistoolbox_install.sh && rm /cmsistoolbox_install.sh
ENV CMSIS_COMPILER_ROOT="/cmsis-toolbox-linux/etc"
ENV PATH="/cmsis-toolbox-linux/bin:/ninja/:/cmake/bin/:${PATH}"

RUN cpackget init https://www.keil.com/pack/index.pidx
