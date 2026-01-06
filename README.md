# AMD Toolchain

This is a docker image containig AMD Vitis SoC (Zynq-7000) and FPGA (Artix 7) toolchain.
- The **Dockerfile.Base** installs Vitis on a ubuntu image.
- The **Dockerfile.Custom** is used to customise the basic installation without having to re-build the whole Vitis image.
- The **vivado** bash script starts the container and launches the Vivado GUI. It's intended for local development. It mounts the current directory to /workspace in the container. Currently, user ID and group are not fixed, so files created from the container might cause permission issues.