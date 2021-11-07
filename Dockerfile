# build with docker build --build-arg VIVADO_VERSION=2018.03 --build-arg VIVADO_TAR_FILE=Xilinx_Vivado_SDK_2018.3_1207_2324 -t vivado .
FROM ubuntu:18.04 AS vivado-clean

# install dependencies for:
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

# set vivado path in environment 
ENV VIVADOPATH=/tools/Xilinx/Vivado/${VIVADO_VERSION}/

# source vivado environemnt
RUN echo '. $VIVADOPATH/settings64.sh' >> ~/.bashrc

# add Digilent board files
FROM vivado-clean AS vivado-digilent

RUN apt-get install -y unzip && \
  wget https://github.com/Digilent/vivado-boards/archive/master.zip -q && \
  unzip master.zip && \
  cp -r vivado-boards-master/new/board_files/* ${VIVADOPATH}/data/boards/board_files && \
  rm -rf vivado-boards-master && \
  rm -rf master.zip && \
  apt-get remove -y unzip