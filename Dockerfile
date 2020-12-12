# This file builds the Docker image for the CSAL Unified Development Enviroment

# Use Official Ubuntu base image
FROM ubuntu:18.04

# Set some variables
ENV USER csal
ENV HOME /home/$USER
ENV DIR pds
ARG DEBIAN_FRONTEND=noninteractive

# Update and upgrade
RUN apt-get update && apt-get upgrade -y && \
    # Install basic dependencies
    apt-get -y install locales sudo build-essential openssh-server \
    # Install libraries usef
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
    automake\
    colordiff\
    openmpi-bin\ 
    libopenmpi-dev \ 
    libopenblas-dev \
    # Install git with lfs support and other packages needed
    git git-lfs dos2unix nano rsync wget curl fish && \
    # Get and extract OpenCilk
    # sends output to /dev/null so that it doesn't thrash 
    # terminal output with download progress.   
    wget https://github.com/OpenCilk/opencilk-project/releases/download/opencilk%2Fbeta3/OpenCilk-9.0.1-Linux.tar.gz >> /dev/null && \
    tar xvzf OpenCilk-9.0.1-Linux.tar.gz >> /dev/null && \ 
    mv OpenCilk-9.0.1-Linux/ /usr/local/ && chmod og+xr /usr/local/OpenCilk-9.0.1-Linux/ -R && mkdir -p /julia

# Get and extract Julia
ENV JULIA_PATH /usr/local/julia
ENV PATH $JULIA_PATH/bin:$PATH

# https://julialang.org/juliareleases.asc
# Julia (Binary signing key) <buildbot@julialang.org>
ENV JULIA_GPG 3673DF529D9049477F76B37566E3C7DC03D6E495

# https://julialang.org/downloads/
ENV JULIA_VERSION 1.5.2

WORKDIR /julia
COPY julia_script.sh . 
RUN sh julia_script.sh >> /dev/null
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
