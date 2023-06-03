#
#包含了Pytorch2.0的镜像,此镜像不包含conda！基于Ubuntu2004构建，并在Windows11 上的WSL2 上构建。支持WSLg。
#由于docker镜像一般都是最精简的，所以会有一些必要的运行库缺失，本镜像补充安装了缺失的运行库。
#这里已经提前安装了Jupyter和SSH启动配置。
#终端中输入 sshstart.sh 即可开启ssh服务。输入jupyter.sh 即可开启jupyter服务。
#
FROM nvidia/cuda:12.0.1-cudnn8-devel-ubuntu20.04

# This Env setting is aimd to display Linux-original window in Windows through WSLg.
ENV DISPLAY=:0 CODEDIR=/opt/project XDG_RUNTIME_DIR=/usr/lib/

# Create a working directory
RUN mkdir $CODEDIR
WORKDIR $CODEDIR

# Remove all third-party apt sources to avoid issues with expiring keys.
RUN rm -f /etc/apt/sources.list.d/*.list && rm -rf /var/lib/apt/lists/*

# Install some basic utilities
RUN apt-get update && apt-get upgrade -y --fix-missing  \
    && apt-get -y --no-install-recommends install  ca-certificates libjpeg-dev libpng-dev\
    sudo git vim traceroute inetutils-ping net-tools curl fontconfig\
    libgl1 libglib2.0-dev libfontconfig libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0  \
    libxcb-shape0 libxcb-xfixes0 libxcb-xinerama0 libxcb-xkb1 libxkbcommon-x11-0 libfontconfig1 libdbus-1-3 libx11-6 \
    openssh-server htop python3-pip

# install python packages
RUN pip install torch torchvision --index-url https://download.pytorch.org/whl/cu118

RUN mkdir /usr/share/fonts/userFonts
COPY ./fonts /usr/share/fonts/userFonts
RUN fc-cache -fv

COPY requirements.txt ./
RUN pip install -r requirements.txt && rm ./requirements.txt &&\
    pip install jupyter-tensorboard
COPY *.sh /usr/local/bin/

LABEL maintainer="LiJianying <lijianying1998@gmail.com>"

RUN rm -r /opt/nvidia/

ENTRYPOINT ["/usr/bin/env"]

CMD ["bash"]