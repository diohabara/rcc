FROM ubuntu:18.04

LABEL version="1.0"
LABEL description="RV32G Compiler Environment"

WORKDIR /tmp/

SHELL ["/bin/bash", "-c"]

RUN apt -y update
RUN apt -y install git autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev

RUN git clone --recursive https://github.com/riscv-collab/riscv-gnu-toolchain.git
ENV RV32 /opt/rv32
RUN cd riscv-gnu-toolchain && \
    mkdir build && cd build && \
    ../configure --prefix=$RV32 --with-arch=rv32g --with-abi=ilp32d && \
    make -j$(nproc)

RUN echo 'export PATH=$PATH:$RV32/bin' >> ~/.bashrc

RUN apt install device-tree-compiler
RUN git clone https://github.com/riscv-software-src/riscv-isa-sim.git
RUN cd riscv-isa-sim && \
    mkdir build && cd build && \
    ../configure --prefix=$RV32 --with-isa=rv32g && \
    make && \
    make install

RUN echo 'export PATH=$PATH:$RV32/bin' >> ~/.bashrc

RUN git clone https://github.com/riscv-software-src/riscv-pk.git
RUN cd riscv-pk && \
    git reset --hard 423801e35d048187d88fcbff55e20c4c34d27bee && \
    mkdir build && cd build && \
    export PATH=$PATH:$RV32/bin && \
    ../configure --prefix=$RV32/pk --host=riscv32-unknown-elf && \
    make && \
    make install

RUN echo 'export PATH=$PATH:$RV32/pk/riscv32-unknown-elf/bin' >> ~/.bashrc

WORKDIR /work
