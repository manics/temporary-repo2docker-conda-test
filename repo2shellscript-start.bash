#!/usr/bin/env bash
set -eux
if [ $(id -un) != jovyan ]; then
    echo ERROR: Must be run as user jovyan
    exit 1
fi
export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export SHELL=/bin/bash
export USER=jovyan
export HOME=/home/jovyan
export APP_BASE=/srv
export NPM_DIR=/srv/npm
export NPM_CONFIG_GLOBALCONFIG=/srv/npm/npmrc
export CONDA_DIR=/srv/conda
export NB_PYTHON_PREFIX=/srv/conda/envs/notebook
export KERNEL_PYTHON_PREFIX=/srv/conda/envs/notebook
export PATH=/home/jovyan/.local/bin:/home/jovyan/.local/bin:/srv/conda/envs/notebook/bin:/srv/conda/bin:/srv/npm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export REPO_DIR=/home/jovyan
export CONDA_DEFAULT_ENV=/srv/conda/envs/notebook
export JUPYTER_TOKEN=${JUPYTER_TOKEN-32f94ee5-755e-4b15-ab76-7432eb4ebca6}
cd /home/jovyan
exec /usr/local/bin/repo2docker-entrypoint jupyter notebook --ip 0.0.0.0
