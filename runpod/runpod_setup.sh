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

# Detect and set CUDA_HOME environment variable for Task Spooler
if command -v nvcc &>/dev/null; then
  # resolve symlinks and strip off /bin/nvcc → /usr/local/cuda-XX.Y
  CUDA_HOME=$(dirname "$(dirname "$(readlink -f "$(command -v nvcc)")")")
elif compgen -G "/usr/local/cuda-*" > /dev/null; then
  # pick the "max" cuda-XX.Y directory by version sort
  CUDA_HOME=$(ls -d /usr/local/cuda-* | sort -V | tail -n1)
else
  echo "⚠️  Cannot find CUDA installation in /usr/local or on your PATH." >&2
  return 1
fi

export CUDA_HOME
echo "→ CUDA_HOME is set to $CUDA_HOME"

# Setup Task Spooler for GPU scheduling
mkdir git && cd git
git clone https://github.com/justanhduc/task-spooler
cd task-spooler
./install_make
cd ..

# Setup dotfiles and ZSH
git clone https://github.com/edonoway/dotfiles.git
cd dotfiles
./install.sh --zsh --tmux
chsh -s /usr/bin/zsh
./deploy.sh

# Setup github
./runpod/setup_github.sh "elizabeth.donoway@gmail.com" "Elizabeth Donoway"
