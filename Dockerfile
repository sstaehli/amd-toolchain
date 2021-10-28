FROM ubuntu:18.04

# build with docker build --build-arg VIVADO_VERSION=2018.03 --build-arg VIVADO_TAR_FILE=Xilinx_Vivado_SDK_2018.3_1207_2324 -t vivado .

#install dependences for:
# * downloading Vivado (wget)
# * xsim (gcc build-essential to also get make)
# * MIG tool (libglib2.0-0 libsm6 libxi6 libxrender1 libxrandr2 libfreetype6 libfontconfig)
# * CI (git)
RUN apt-get update && apt-get install -y \
  wget \
  python \
  build-essential \
  libglib2.0-0 \
  libsm6 \
  libxi6 \
  libxrender1 \
  libxrandr2 \
  libfreetype6 \
  libfontconfig \
  git

# copy in config file
COPY install_config.txt /

# download and run the install
ARG VIVADO_TAR_FILE
ARG VIVADO_VERSION

RUN wget ${VIVADO_TAR_FILE} -q && \
  tar xzf $(basename ${VIVADO_TAR_FILE}) && \
  /$(basename ${VIVADO_TAR_FILE} .tar.gz)/xsetup --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA --batch Install --config install_config.txt && \
  rm -rf /$(basename ${VIVADO_TAR_FILE} .tar.gz)*

#copy in the license file (root)
RUN mkdir -p /root/.Xilinx
COPY Xilinx.lic /root/.Xilinx/

# Copy and unpack linaro toolchain for cross compilation
ADD gcc-linaro-4.9.4-2017.01-i686_arm-linux-gnueabi.tar.gz /tools/
ADD gcc-linaro-7.5.0-2019.12-i686_arm-linux-gnueabihf.tar.gz /tools/

#install packages required for u-boot
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
  libz1:i386 \
  libswt-gtk-4-java \
  xvfb \
  x11-utils \
  bison \
  flex \
  libssl-dev

# set vivado path in environment 
ENV VIVADOPATH=/tools/Xilinx/Vivado/${VIVADO_VERSION}/
