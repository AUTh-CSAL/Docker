# This file builds the Docker image for the CSAL Unified Development Enviroment

# Use Official Ubuntu base image
FROM ubuntu:18.04

# Set some variables
ENV USER csal
ENV HOME /home/$USER
ENV DIR pds

# Avoid stall during installation of tzdata
ENV TZ=Europe/Athens
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update and upgrade
RUN apt-get update && apt-get upgrade -y

# Install basic dependencies
RUN apt-get -y install locales sudo build-essential openssh-server

# Install libraries usef
RUN apt-get update && apt-get install -y \
     gcc \
#    nlohmann-json-dev \
#    libshp-dev \
#    liblas-dev \   #need to build from source to support LASZip
#    liblas-c-dev \
#    libpugixml-dev \
#    libproj-dev \
#    libtriangle-dev \
#    libnetcdf-c++4-dev \
    clang-format \
    clang-tidy \
    ca-certificates \
#    doxygen graphviz\
#    libgeotiff-dev\
    automake\
    colordiff\
    openmpi-bin\ 
    libopenmpi-dev 

# Install git with lfs support, dos2unix, nano simple editor, rsync and wget
RUN apt-get update && apt-get install -y git git-lfs dos2unix nano rsync wget curl

# Get and extract OpenCilk
RUN wget https://github.com/OpenCilk/opencilk-project/releases/download/opencilk%2Fbeta3/OpenCilk-9.0.1-Linux.tar.gz && tar xvzf OpenCilk-9.0.1-Linux.tar.gz 
RUN mv OpenCilk-9.0.1-Linux/ /usr/local/ && chmod g+xr /usr/local/OpenCilk-9.0.1-Linux/bin/ && chmod o+x /usr/local/OpenCilk-9.0.1-Linux/bin/

# Get and extract Julia
#RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.5/julia-1.5.2-linux-x86_64.tar.gz
#RUN tar xvzf julia-1.5.2-linux-x86_64.tar.gz
#RUN rm -rf julia-1.5.2-linux-x86_64.tar.gz
#RUN mv julia-1.5.2-linux-x86_64/ $HOME

# Add user and change to user
RUN useradd -m $USER -G sudo && \
    echo "$USER:$USER" | chpasswd && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER $USER

# Create shared volume
VOLUME $HOME/$DIR
WORKDIR $HOME/$DIR

# Generate welcome message printed at login
COPY Welcome $HOME/.welcome
RUN echo "cat $HOME/.welcome" >> $HOME/.bashrc

# Start bash login shell
ENTRYPOINT ["/bin/bash", "-l", "-c"]
CMD ["/bin/bash", "-i"]
