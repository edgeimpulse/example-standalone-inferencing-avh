FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /app

RUN  apt-get update && apt-get install -y wget sudo software-properties-common && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash arm_mlops_docker

RUN if [ $(uname -m) = "x86_64" ]; then export ARCH=x86_64; else export ARCH=aarch64; fi

#ADD ./tools/armclang_install.sh /armclang_install.sh
#RUN chmod +x /armclang_install.sh && /armclang_install.sh

COPY ./tools/vela_install.sh /vela_install.sh
RUN chmod +x /vela_install.sh && /bin/bash /vela_install.sh && rm /vela_install.sh

COPY ./tools/avh-fvp_install.sh /avh-fvp_install.sh
RUN chmod +x /avh-fvp_install.sh && /bin/bash /avh-fvp_install.sh && rm /avh-fvp_install.sh

COPY ./tools/armllvm_install.sh /armllvm_install.sh
RUN chmod +x /armllvm_install.sh && /armllvm_install.sh && rm /armllvm_install.sh

COPY ./tools/armgcc_install.sh /armgcc_install.sh
RUN chmod +x /armgcc_install.sh && /bin/bash /armgcc_install.sh && rm /armgcc_install.sh

COPY ./tools/cmsistoolbox_install.sh /cmsistoolbox_install.sh
RUN chmod +x /cmsistoolbox_install.sh && /bin/bash /cmsistoolbox_install.sh && rm /cmsistoolbox_install.sh

#RUN cpackget init https://www.keil.com/pack/index.pidx
