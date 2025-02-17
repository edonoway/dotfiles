#!/bin/bash

# 1) Setup linux dependencies
su -c 'apt-get update && apt-get install sudo'
sudo apt-get install less nano htop ncdu vim tree nvtop jq

# 2) Setup virtual environment
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
uv tool install "huggingface_hub[cli]"
# uv python install 3.11
# uv venv
# source .venv/bin/activate
# uv pip install ipykernel simple-gpu-scheduler # very useful on runpod with multi-GPUs https://pypi.org/project/simple-gpu-scheduler/
# python -m ipykernel install --user --name=venv # so it shows up in jupyter notebooks within vscode

# 3) Setup dotfiles and ZSH
mkdir git && cd git
git clone https://github.com/edonoway/dotfiles.git
cd dotfiles
./install.sh --zsh --tmux
chsh -s /usr/bin/zsh
./deploy.sh

# 4) Setup github
./runpod/setup_github.sh "elizabeth.donoway@gmail.com" "Elizabeth Donoway"
