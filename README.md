# rcc

RISC-V C compiler

## How to set up

For macOS

```bash
brew tap riscv-software-src/riscv
brew install riscv-tools
```

## How to run it

```bash
riscv64-unknown-elf-gcc -c hello.s -o hello.o
riscv64-unknown-elf-gcc hello.o -o hello
spike pk hello
```

