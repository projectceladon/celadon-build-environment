FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y wget openjdk-8-jdk git ccache automake \
       lzop bison gperf build-essential zip curl \
       zlib1g-dev g++-multilib python3-networkx \
       libxml2-utils bzip2 libbz2-dev libbz2-1.0 \
       libghc-bzlib-dev squashfs-tools pngcrush \
       schedtool dpkg-dev liblz4-tool make optipng maven \
       libssl-dev bc bsdmainutils gettext python3-mako \
       libelf-dev sbsigntool dosfstools mtools efitools \
       python3-pystache git-lfs python-is-python3 flex clang libncurses5 \
       fakeroot ncurses-dev xz-utils cryptsetup-bin \
       apt-transport-https ca-certificates curl lsb-release \
       rsync vim python-six kmod\
       software-properties-common cpio python3-pip ninja-build \
       cutils cmake pkg-config xorriso mtools libjson-c-dev file \
       libxinerama-dev python3-pyelftools &&\
       dpkg-reconfigure -p critical dash


RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update && \
    apt-get -y install git-lfs


RUN pip3 install meson==1.1.0
RUN pip3 install mako==1.1.0
RUN pip3 install dataclasses
RUN pip3 install pycryptodome
RUN pip3 install ply==3.11


RUN dpkg --add-architecture i386
RUN wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB  | gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list  
RUN  apt-get update && \
    apt-get install -y intel-oneapi-ipp-devel-2021.10 \
    intel-oneapi-mkl-devel-2021.1.1 intel-oneapi-ipp-devel-32bit-2021.10 intel-oneapi-mkl-devel-32bit-2021.1.1


RUN apt-get install -y sudo --option=Dpkg::Options::=--force-confdef
ADD ./sudoers /etc/sudoers

WORKDIR /usr/local/

RUN apt update &&  apt install -y glslang-tools

WORKDIR /

#creating user celadonuser
ENV CUSER celadon
ENV CUSERHOME /home/$CUSER
ENV CGRP celadon

RUN groupadd -g 9999 $CGRP && \
useradd -m -d $CUSERHOME -g $CGRP  $CUSER

ADD ./.gitconfig ${CUSERHOME}
RUN chown celadon:celadon $CUSERHOME/.gitconfig

USER $CUSER

WORKDIR  /home/$CUSER


#google repo installation steps

RUN mkdir -p ${CUSERHOME}/.bin
ENV PATH ${CUSERHOME}/.bin:${PATH}
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > ${CUSERHOME}/.bin/repo
RUN chmod a+rx ${CUSERHOME}/.bin/repo
