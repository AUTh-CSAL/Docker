# This file builds the Docker image for the CSAL Unified Development Enviroment

ARG DEBIAN_FRONTEND=noninteractive
ARG OPENCILK_VERSION=2.1.0

FROM ubuntu:24.04 AS opencilk
ARG DEBIAN_FRONTEND
ARG OPENCILK_VERSION

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl && \
    curl -sLf -o opencilk.tar.gz https://github.com/OpenCilk/opencilk-project/releases/download/opencilk%2Fv2.1/opencilk-${OPENCILK_VERSION}-x86_64-linux-gnu-ubuntu-22.04.tar.gz >> /dev/null && \
    tar xvzf opencilk.tar.gz >> /dev/null && \ 
    rm opencilk.tar.gz && \
    mv opencilk-${OPENCILK_VERSION}-x86_64-linux-gnu-ubuntu-22.04/ /usr/local/ && \
    chmod og+xr /usr/local/opencilk-${OPENCILK_VERSION}-x86_64-linux-gnu-ubuntu-22.04/ -R

# Use Official Ubuntu base image
FROM ubuntu:24.04 AS final

# Set some variables
ARG USER=csal
ENV HOME=/home/$USER
ENV DIR=pds
ARG DEBIAN_FRONTEND
ARG JULIA_VERSION=1.11.1
ARG OPENCILK_VERSION

COPY --chown=${USER}:${USER} Welcome ${HOME}/.welcome
COPY --from=opencilk /usr/local/opencilk-${OPENCILK_VERSION}-x86_64-linux-gnu-ubuntu-22.04/ /usr/local/opencilk-${OPENCILK_VERSION}-x86_64-linux-gnu-ubuntu-22.04/

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
    libopenmpi-dev\
    libopenblas-dev\ 
    # Install git with lfs support and other packages needed
    git git-lfs dos2unix nano rsync curl fish && \
    # Get and extract OpenCilk
    # sends output to /dev/null so that it doesn't thrash 
    # terminal output with download progress.   
    curl -fsSL https://install.julialang.org | sh -s -- --yes --default-channel ${JULIA_VERSION} && \
    # Add user and change to user
    useradd -m -G sudo ${USER} && \
    echo "${USER}:${USER}" | chpasswd && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chown -R ${USER}:${USER} ${HOME} && \
    echo "cat ${HOME}/.welcome" >> ${HOME}/.bashrc && \
    echo "PATH=\$PATH:${HOME}/.juliaup/bin:/usr/local/opencilk-${OPENCILK_VERSION}-x86_64-linux-gnu-ubuntu-22.04/bin" >> ${HOME}/.bashrc

USER $USER

# Create shared volume
VOLUME ${HOME}/${DIR}
WORKDIR ${HOME}/${DIR}

# Start bash login shell
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/bash", "-i"]
