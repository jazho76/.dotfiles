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
git clone git@github.com:jazho76/.dotfiles.git ~/.dotfiles
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
