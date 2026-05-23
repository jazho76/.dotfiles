# Dotfiles

This repository contains my dotfiles. I use [GNU Stow](https://www.gnu.org/software/stow/) to manage them.

## Install Stow

Ubuntu

```bash
sudo apt install stow
```

Fedora

```bash
sudo dnf install stow
```

## Clone Repository

```bash
git clone --recurse-submodules git@github.com:jpinilloslr/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

## Install Bash Config

```bash
stow bash
```

## Install Alacritty Config

```bash
stow alacritty
```

## Install Git Config

```bash
stow git
```

## Install Nvim Config

### Uninstall previous version

```bash
rm -rf ~/.local/nvim
sudo rm /usr/local/bin/nvim
```

### Remove previous data and cache

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
rm -rf ~/.config/nvim
```

### Install Nvim

```bash
VERSION=0.12.2
curl -L https://github.com/neovim/neovim/releases/download/v$VERSION/nvim-linux-x86_64.tar.gz -o nvim-linux-x86_64.tar.gz
tar xzvf nvim-linux-x86_64.tar.gz
rm ./nvim-linux-x86_64.tar.gz
mkdir -p ~/.local
mkdir -p ~/.config
mv ./nvim-linux-x86_64 ~/.local/nvim
sudo ln -s ~/.local/nvim/bin/nvim /usr/local/bin/nvim
```

### Install Config

```bash
stow nvim
```

### Additional Tools

**Install ripgrep for Telescope**

```bash
sudo apt install ripgrep
```

**Install wl-clipboard for Wayland clipboard synchronization.**

```bash
sudo apt install wl-clipboard
```

**Install xclip for X11 clipboard synchronization.**

```bash
sudo apt install xclip
```

**Install Nerd Fonts for icons**

```bash
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/DroidSansMono.zip -o DroidSansMono.zip
unzip DroidSansMono.zip -d DroidSansMono/
mkdir -p ~/.local/share/fonts/
cp ./DroidSansMono/*.otf ~/.local/share/fonts/
rm -rf ./DroidSansMono
rm ./DroidSansMono.zip
fc-cache -fv
fc-list | grep "DroidSansM"
```

Change terminal font to "DroidSansM Nerd Font Mono" 12pts

Open nvim so it can install all plugins.

## Install Tmux Config

```
stow tmux
```

Install TPM

```
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Open Tmux and press Ctr+A I to install all plugins.

## Install GDB Config

```bash
stow gdb
```

## Install Pwntools Config

```bash
stow pwntools
```
