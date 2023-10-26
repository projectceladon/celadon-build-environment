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
       rsync vim python-six \
       software-properties-common cpio python3-pip ninja-build \
       cutils cmake pkg-config xorriso mtools libjson-c-dev file


RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update && \
    apt-get -y install git-lfs

RUN pip3 install meson==0.60.0
RUN pip3 install mako==1.1.0
RUN pip3 install dataclasses

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
