#!/usr/bin/env bash
set -eux
_REPO2SHELLSCRIPT_SRCDIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

# FROM buildpack-deps:bionic
# https://github.com/docker-library/buildpack-deps/tree/f84f6184d79f2cb7ab94c365ac4f47915e7ca2a8/ubuntu/bionic
# With the addition of
# - sudo since it makes it easier to switch USER

apt-get -qq update

# buildpack-deps:bionic-curl
# buildpack-deps:bionic-scm
# buildpack-deps:bionic
# + sudo

apt-get -qq install --yes --no-install-recommends \
    ca-certificates \
    curl \
    netbase \
    wget \
    \
    gnupg \
    dirmngr \
    \
    bzr \
    git \
    mercurial \
    openssh-client \
    subversion \
    procps \
    \
    autoconf \
    automake \
    bzip2 \
    dpkg-dev \
    file \
    g++ \
    gcc \
    imagemagick \
    libbz2-dev \
    libc6-dev \
    libcurl4-openssl-dev \
    libdb-dev \
    libevent-dev \
    libffi-dev \
    libgdbm-dev \
    libglib2.0-dev \
    libgmp-dev \
    libjpeg-dev \
    libkrb5-dev \
    liblzma-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libmaxminddb-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libpng-dev \
    libpq-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libwebp-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    make \
    patch \
    unzip \
    xz-utils \
    zlib1g-dev \
    \
    sudo

if apt-cache show 'default-libmysqlclient-dev' 2>/dev/null | grep -q '^Version:'; then
    echo 'default-libmysqlclient-dev'
else
    echo 'libmysqlclient-dev'
fi
rm -rf /var/lib/apt/lists/*

# avoid prompts from apt

# ENV DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND=noninteractive

# Set up locales properly

# RUN apt-get -qq update && \
#     apt-get -qq install --yes --no-install-recommends locales > /dev/null && \
#     apt-get -qq purge && \
#     apt-get -qq clean && \
#     rm -rf /var/lib/apt/lists/*
apt-get -qq update &&     apt-get -qq install --yes --no-install-recommends locales > /dev/null &&     apt-get -qq purge &&     apt-get -qq clean &&     rm -rf /var/lib/apt/lists/*

# RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
#     locale-gen
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen &&     locale-gen

# ENV LC_ALL en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ENV LANG en_US.UTF-8
export LANG=en_US.UTF-8

# ENV LANGUAGE en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Use bash as default shell, rather than sh

# ENV SHELL /bin/bash
export SHELL=/bin/bash

# Set up user

# ARG NB_USER
export NB_USER=jovyan

# ARG NB_UID
export NB_UID=1000

# ENV USER ${NB_USER}
export USER=jovyan

# ENV HOME /home/${NB_USER}
export HOME=/home/jovyan

# RUN groupadd \
#         --gid ${NB_UID} \
#         ${NB_USER} && \
#     useradd \
#         --comment "Default user" \
#         --create-home \
#         --gid ${NB_UID} \
#         --no-log-init \
#         --shell /bin/bash \
#         --uid ${NB_UID} \
#         ${NB_USER}
groupadd         --gid ${NB_UID}         ${NB_USER} &&     useradd         --comment "Default user"         --create-home         --gid ${NB_UID}         --no-log-init         --shell /bin/bash         --uid ${NB_UID}         ${NB_USER}

# RUN wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key |  apt-key add - && \
#     DISTRO="bionic" && \
#     echo "deb https://deb.nodesource.com/node_10.x $DISTRO main" >> /etc/apt/sources.list.d/nodesource.list && \
#     echo "deb-src https://deb.nodesource.com/node_10.x $DISTRO main" >> /etc/apt/sources.list.d/nodesource.list
wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key |  apt-key add - &&     DISTRO="bionic" &&     echo "deb https://deb.nodesource.com/node_10.x $DISTRO main" >> /etc/apt/sources.list.d/nodesource.list &&     echo "deb-src https://deb.nodesource.com/node_10.x $DISTRO main" >> /etc/apt/sources.list.d/nodesource.list

# Base package installs are not super interesting to users, so hide their outputs

# If install fails for some reason, errors will still be printed

# RUN apt-get -qq update && \
#     apt-get -qq install --yes --no-install-recommends \
#        less \
#        nodejs \
#        unzip \
#        > /dev/null && \
#     apt-get -qq purge && \
#     apt-get -qq clean && \
#     rm -rf /var/lib/apt/lists/*
apt-get -qq update &&     apt-get -qq install --yes --no-install-recommends        less        nodejs        unzip        > /dev/null &&     apt-get -qq purge &&     apt-get -qq clean &&     rm -rf /var/lib/apt/lists/*

# EXPOSE 8888

# Environment variables required for build

# ENV APP_BASE /srv
export APP_BASE=/srv

# ENV NPM_DIR ${APP_BASE}/npm
export NPM_DIR=/srv/npm

# ENV NPM_CONFIG_GLOBALCONFIG ${NPM_DIR}/npmrc
export NPM_CONFIG_GLOBALCONFIG=/srv/npm/npmrc

# ENV CONDA_DIR ${APP_BASE}/conda
export CONDA_DIR=/srv/conda

# ENV NB_PYTHON_PREFIX ${CONDA_DIR}/envs/notebook
export NB_PYTHON_PREFIX=/srv/conda/envs/notebook

# ENV KERNEL_PYTHON_PREFIX ${NB_PYTHON_PREFIX}
export KERNEL_PYTHON_PREFIX=/srv/conda/envs/notebook

# Special case PATH

# ENV PATH ${NB_PYTHON_PREFIX}/bin:${CONDA_DIR}/bin:${NPM_DIR}/bin:${PATH}
export PATH=/srv/conda/envs/notebook/bin:/srv/conda/bin:/srv/npm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# If scripts required during build are present, copy them

# COPY build_script_files/-2fhome-2fsimon-2fwork-2fjupyter-2frepo2docker-2frepo2docker-2fbuildpacks-2fconda-2factivate-2dconda-2esh-7b6d52 /etc/profile.d/activate-conda.sh
if [ -d "${_REPO2SHELLSCRIPT_SRCDIR}"/build_script_files/-2fhome-2fsimon-2fwork-2fjupyter-2frepo2docker-2frepo2docker-2fbuildpacks-2fconda-2factivate-2dconda-2esh-7b6d52 ]; then cp -a "${_REPO2SHELLSCRIPT_SRCDIR}"/build_script_files/-2fhome-2fsimon-2fwork-2fjupyter-2frepo2docker-2frepo2docker-2fbuildpacks-2fconda-2factivate-2dconda-2esh-7b6d52/* /etc/profile.d/activate-conda.sh; else cp "${_REPO2SHELLSCRIPT_SRCDIR}"/build_script_files/-2fhome-2fsimon-2fwork-2fjupyter-2frepo2docker-2frepo2docker-2fbuildpacks-2fconda-2factivate-2dconda-2esh-7b6d52 /etc/profile.d/activate-conda.sh; fi

# COPY build_script_files/-2fhome-2fsimon-2fwork-2fjupyter-2frepo2docker-2frepo2docker-2fbuildpacks-2fconda-2fenvironment-2efrozen-2eyml-a0c50b /tmp/environment.yml
if [ -d "${_REPO2SHELLSCRIPT_SRCDIR}"/build_script_files/-2fhome-2fsimon-2fwork-2fjupyter-2frepo2docker-2frepo2docker-2fbuildpacks-2fconda-2fenvironment-2efrozen-2eyml-a0c50b ]; then cp -a "${_REPO2SHELLSCRIPT_SRCDIR}"/build_script_files/-2fhome-2fsimon-2fwork-2fjupyter-2frepo2docker-2frepo2docker-2fbuildpacks-2fconda-2fenvironment-2efrozen-2eyml-a0c50b/* /tmp/environment.yml; else cp "${_REPO2SHELLSCRIPT_SRCDIR}"/build_script_files/-2fhome-2fsimon-2fwork-2fjupyter-2frepo2docker-2frepo2docker-2fbuildpacks-2fconda-2fenvironment-2efrozen-2eyml-a0c50b /tmp/environment.yml; fi

# COPY build_script_files/-2fhome-2fsimon-2fwork-2fjupyter-2frepo2docker-2frepo2docker-2fbuildpacks-2fconda-2finstall-2dminiforge-2ebash-1ffeea /tmp/install-miniforge.bash
if [ -d "${_REPO2SHELLSCRIPT_SRCDIR}"/build_script_files/-2fhome-2fsimon-2fwork-2fjupyter-2frepo2docker-2frepo2docker-2fbuildpacks-2fconda-2finstall-2dminiforge-2ebash-1ffeea ]; then cp -a "${_REPO2SHELLSCRIPT_SRCDIR}"/build_script_files/-2fhome-2fsimon-2fwork-2fjupyter-2frepo2docker-2frepo2docker-2fbuildpacks-2fconda-2finstall-2dminiforge-2ebash-1ffeea/* /tmp/install-miniforge.bash; else cp "${_REPO2SHELLSCRIPT_SRCDIR}"/build_script_files/-2fhome-2fsimon-2fwork-2fjupyter-2frepo2docker-2frepo2docker-2fbuildpacks-2fconda-2finstall-2dminiforge-2ebash-1ffeea /tmp/install-miniforge.bash; fi

# RUN mkdir -p ${NPM_DIR} && \
# chown -R ${NB_USER}:${NB_USER} ${NPM_DIR}
mkdir -p ${NPM_DIR} && chown -R ${NB_USER}:${NB_USER} ${NPM_DIR}

# USER ${NB_USER}

# RUN npm config --global set prefix ${NPM_DIR}
sudo -u ${NB_USER} --preserve-env=DEBIAN_FRONTEND,LC_ALL,LANG,LANGUAGE,SHELL,NB_USER,NB_UID,USER,HOME,APP_BASE,NPM_DIR,NPM_CONFIG_GLOBALCONFIG,CONDA_DIR,NB_PYTHON_PREFIX,KERNEL_PYTHON_PREFIX,PATH bash -c 'npm config --global set prefix ${NPM_DIR}'

# USER root

# RUN bash /tmp/install-miniforge.bash && \
# rm /tmp/install-miniforge.bash /tmp/environment.yml
bash /tmp/install-miniforge.bash && rm /tmp/install-miniforge.bash /tmp/environment.yml

# Allow target path repo is cloned to be configurable

# ARG REPO_DIR=${HOME}
export REPO_DIR=/home/jovyan

# ENV REPO_DIR ${REPO_DIR}
export REPO_DIR=/home/jovyan

# WORKDIR ${REPO_DIR}
cd ${REPO_DIR}

# We want to allow two things:

#   1. If there's a .local/bin directory in the repo, things there

#      should automatically be in path

#   2. postBuild and users should be able to install things into ~/.local/bin

#      and have them be automatically in path

#

# The XDG standard suggests ~/.local/bin as the path for local user-specific

# installs. See https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

# ENV PATH ${HOME}/.local/bin:${REPO_DIR}/.local/bin:${PATH}
export PATH=/home/jovyan/.local/bin:/home/jovyan/.local/bin:/srv/conda/envs/notebook/bin:/srv/conda/bin:/srv/npm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# The rest of the environment

# ENV CONDA_DEFAULT_ENV ${KERNEL_PYTHON_PREFIX}
export CONDA_DEFAULT_ENV=/srv/conda/envs/notebook

# Run pre-assemble scripts! These are instructions that depend on the content

# of the repository but don't access any files in the repository. By executing

# them before copying the repository itself we can cache these steps. For

# example installing APT packages.

# If scripts required during build are present, copy them

# COPY src/environment.yml ${REPO_DIR}/environment.yml
if [ -d "${_REPO2SHELLSCRIPT_SRCDIR}"/src/environment.yml ]; then cp -a "${_REPO2SHELLSCRIPT_SRCDIR}"/src/environment.yml/* ${REPO_DIR}/environment.yml; else cp "${_REPO2SHELLSCRIPT_SRCDIR}"/src/environment.yml ${REPO_DIR}/environment.yml; fi

# USER root

# RUN chown -R ${NB_USER}:${NB_USER} ${REPO_DIR}
chown -R ${NB_USER}:${NB_USER} ${REPO_DIR}

# USER ${NB_USER}

# RUN conda env update -p ${NB_PYTHON_PREFIX} -f "environment.yml" && \
# conda clean --all -f -y && \
# conda list -p ${NB_PYTHON_PREFIX}
sudo -u ${NB_USER} --preserve-env=DEBIAN_FRONTEND,LC_ALL,LANG,LANGUAGE,SHELL,NB_USER,NB_UID,USER,HOME,APP_BASE,NPM_DIR,NPM_CONFIG_GLOBALCONFIG,CONDA_DIR,NB_PYTHON_PREFIX,KERNEL_PYTHON_PREFIX,PATH,REPO_DIR,CONDA_DEFAULT_ENV bash -c 'conda env update -p ${NB_PYTHON_PREFIX} -f "environment.yml" && conda clean --all -f -y && conda list -p ${NB_PYTHON_PREFIX}'

# Copy and chown stuff. This doubles the size of the repo, because

# you can't actually copy as USER, only as root! Thanks, Docker!

# USER root

# COPY src/ ${REPO_DIR}
if [ -d "${_REPO2SHELLSCRIPT_SRCDIR}"/src ]; then cp -a "${_REPO2SHELLSCRIPT_SRCDIR}"/src/* ${REPO_DIR}; else cp "${_REPO2SHELLSCRIPT_SRCDIR}"/src ${REPO_DIR}; fi

# RUN chown -R ${NB_USER}:${NB_USER} ${REPO_DIR}
chown -R ${NB_USER}:${NB_USER} ${REPO_DIR}

# Run assemble scripts! These will actually turn the specification

# in the repository into an image.

# Container image Labels!

# Put these at the end, since we don't want to rebuild everything

# when these change! Did I mention I hate Dockerfile cache semantics?

# LABEL repo2docker.ref="None"

# LABEL repo2docker.repo="https://github.com/binder-examples/conda"

# LABEL repo2docker.version="0.11.0+166.gc1afe63.dirty"

# We always want containers to run as non-root

# USER ${NB_USER}

# Add start script

# Add entrypoint

# COPY /repo2docker-entrypoint /usr/local/bin/repo2docker-entrypoint
if [ -d "${_REPO2SHELLSCRIPT_SRCDIR}"/repo2docker-entrypoint ]; then cp -a "${_REPO2SHELLSCRIPT_SRCDIR}"/repo2docker-entrypoint/* /usr/local/bin/repo2docker-entrypoint; else cp "${_REPO2SHELLSCRIPT_SRCDIR}"/repo2docker-entrypoint /usr/local/bin/repo2docker-entrypoint; fi

# ENTRYPOINT ["/usr/local/bin/repo2docker-entrypoint"]

# Specify the default command to run

# CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]

