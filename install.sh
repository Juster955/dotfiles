#!/bin/bash

# Because I'm not familiar with the grammer of <.sh> files, I use AI (actually DeepSeek) to help me to write this script.

# Exit immediately if any command fails
set -e

# Get the absolute path of the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "======================================"
echo "    Dotfiles Setup for Cloud Server"
echo "======================================"

# Safe link function (backs up existing files)
safe_link() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "Warning: Backing up existing $dest to ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    ln -sf "$src" "$dest"
    echo "Linked: $dest -> $src"
}

# ======================================
# 1. Hostname Customization (Interactive)
# ======================================
read -p "Do you want to customize the prompt hostname? (y/N): " DO_CUSTOM
if [[ "$DO_CUSTOM" =~ ^[Yy]$ ]]; then
    read -p "Enter the hostname you want to display: " CUSTOM_HOST
    
    > "$HOME/.zshrc.local"
    cat <<EOF >> "$HOME/.zshrc.local"
prompt_context() {
  if [[ "\$USER" != "root" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)\$USER@$CUSTOM_HOST"
  fi
}
EOF
    echo "Prompt hostname customized to: $CUSTOM_HOST"
else
    echo "Skipping prompt hostname customization."
fi

# ======================================
# 2. Install Base Software
# ======================================
echo "======================================"
echo "Updating package lists..."
sudo apt update

echo "Installing packages..."
sudo apt install -y zsh neofetch tree build-essential gdb p7zip-full curl git wget

# ======================================
# 3. Install Oh My Zsh (Silent mode)
# ======================================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ======================================
# 4. Install Zsh Plugins (Gitee Mirror)
# ======================================
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://gitee.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://gitee.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# ======================================
# 5. Deploy .zshrc
# ======================================
echo "======================================"
echo "Deploying configurations..."

safe_link "$DOTFILES_DIR/terminal/.zshrc" "$HOME/.zshrc"

echo "======================================"
echo "Setup Complete! Please run: source ~/.zshrc"
echo "======================================"
