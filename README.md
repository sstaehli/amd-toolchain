# AMD Toolchain

This is a docker image containig AMD Vitis SoC (Zynq-7000) and FPGA (Artix 7) toolchain. Download the unified installer from https://www.xilinx.com/support/download.html and place the tar file in the root of your repo/workspace.
- The **Dockerfile.Base** installs Vitis on a ubuntu image.
- The **Dockerfile.Custom** is used to customise the basic installation without having to re-build the whole Vitis image.
- Use the **vivado-docker** and **vitis-docker** bash scripts to start the container and launches the Vivado or Vitis GUI. It's intended for local development. It mounts the current directory to /workspace in the container with user rights.
