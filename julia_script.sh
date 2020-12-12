#!/bin/bash
set -eux; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    if ! command -v gpg > /dev/null; then \
        apt-get update; \
        apt-get install -y --no-install-recommends \
            gnupg \
            dirmngr \
        ; \
        rm -rf /var/lib/apt/lists/*; \
    fi; \
    \
# https://julialang.org/downloads/#julia-command-line-version
# https://julialang-s3.julialang.org/bin/checksums/julia-1.5.1.sha256
# this "case" statement is generated via "update.sh"
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
# amd64
        amd64) tarArch='x86_64'; dirArch='x64'; sha256='6da704fadcefa39725503e4c7a9cfa1a570ba8a647c4bd8de69a118f43584630' ;; \
        *) echo >&2 "error: current architecture ($dpkgArch) does not have a corresponding Julia binary release"; exit 1 ;; \
    esac; \
    \
    folder="$(echo "$JULIA_VERSION" | cut -d. -f1-2)"; \
    curl -fL -o julia.tar.gz.asc "https://julialang-s3.julialang.org/bin/linux/${dirArch}/${folder}/julia-${JULIA_VERSION}-linux-${tarArch}.tar.gz.asc"; \
    curl -fL -o julia.tar.gz     "https://julialang-s3.julialang.org/bin/linux/${dirArch}/${folder}/julia-${JULIA_VERSION}-linux-${tarArch}.tar.gz"; \
    \
    echo "${sha256} *julia.tar.gz" | sha256sum -c -; \
    \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$JULIA_GPG"; \
    gpg --batch --verify julia.tar.gz.asc julia.tar.gz; \
    command -v gpgconf > /dev/null && gpgconf --kill all; \
    rm -rf "$GNUPGHOME" julia.tar.gz.asc; \
    \
    mkdir "$JULIA_PATH"; \
    tar -xzf julia.tar.gz -C "$JULIA_PATH" --strip-components 1; \
    rm julia.tar.gz; \
    \
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    \
# smoke test
    julia --version