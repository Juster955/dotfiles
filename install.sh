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
if [ -f "$HOME/.zshrc.local" ]; then
    echo "~/.zshrc.local already exists, skipping hostname customization."
else
    read -p "Do you want to customize the prompt hostname? (y/N): " DO_CUSTOM
    if [[ "$DO_CUSTOM" =~ ^[Yy]$ ]]; then
        read -p "Enter the hostname you want to display: " CUSTOM_HOST

        if [ -z "$CUSTOM_HOST" ]; then
            echo "Empty hostname, skipping customization."
        else
            cat > "$HOME/.zshrc.local" <<EOF
prompt_context() {
  if [[ "\$USER" != "root" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)\$USER@$CUSTOM_HOST"
  fi
}
EOF
            echo "Prompt hostname customized to: $CUSTOM_HOST"
        fi
    else
        echo "Skipping prompt hostname customization."
    fi
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

# ======================================
# 6. Deploy .gitconfig
# ======================================
echo "======================================"
echo "Deploying .gitconfig..."

# Grab identity the machine already has (e.g. hand-written ~/.gitconfig).
# Use --file so include is NOT expanded: we want the raw file, not our template.
EXISTING_NAME=""
EXISTING_EMAIL=""
if [ -f "$HOME/.gitconfig" ]; then
    EXISTING_NAME="$(git config --file "$HOME/.gitconfig" user.name 2>/dev/null || true)"
    EXISTING_EMAIL="$(git config --file "$HOME/.gitconfig" user.email 2>/dev/null || true)"
fi

safe_link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

if [ -f "$HOME/.gitconfig.local" ]; then
    echo "~/.gitconfig.local already exists, skipping."
else
    echo "No ~/.gitconfig.local found, creating one."

    if [ -n "$EXISTING_NAME" ]; then
        read -p "Git user name [$EXISTING_NAME]: " GIT_NAME
        GIT_NAME="${GIT_NAME:-$EXISTING_NAME}"
    else
        while [ -z "$GIT_NAME" ]; do
            read -p "Git user name: " GIT_NAME
        done
    fi

    if [ -n "$EXISTING_EMAIL" ]; then
        read -p "Git email [$EXISTING_EMAIL]: " GIT_EMAIL
        GIT_EMAIL="${GIT_EMAIL:-$EXISTING_EMAIL}"
    else
        while [ -z "$GIT_EMAIL" ]; do
            read -p "Git email: " GIT_EMAIL
        done
    fi

    cat > "$HOME/.gitconfig.local" <<EOF
[user]
	name = $GIT_NAME
	email = $GIT_EMAIL
EOF

    echo "Created ~/.gitconfig.local:"
    cat "$HOME/.gitconfig.local"
    echo "Note: this file is NOT tracked by git."
fi

echo "======================================"
echo "Setup Complete! Please run: source ~/.zshrc"
echo "======================================"
