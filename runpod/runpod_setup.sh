#!/bin/bash
set -euxo pipefail

# Setup linux dependencies
su -c 'apt-get update && apt-get install sudo'
sudo apt-get install -y less nano vim htop btop nvtop ncdu lsof rsync tree jq fzf ripgrep npm

# Setup uv for package/project management
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
uv tool install "huggingface_hub[cli]"

# Update Node.js to latest version (for Claude code)
sudo apt-get remove -y nodejs
sudo dpkg --remove --force-remove-reinstreq libnode-dev
curl -fsSL https://deb.nodesource.com/setup_23.x | sudo -E bash -
sudo apt-get install -y nodejs

# Claude code
npm install -g @anthropic-ai/claude-code

# Setup dotfiles and ZSH
mkdir git && cd git
git clone https://github.com/edonoway/dotfiles.git
cd dotfiles
./install.sh --zsh --tmux
chsh -s /usr/bin/zsh
./deploy.sh

# Setup github
./runpod/setup_github.sh "elizabeth.donoway@gmail.com" "Elizabeth Donoway"
