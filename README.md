# Dotfiles

Personal NixOS flake + user configs managed with GNU Stow.

## Structure

```
nixos/          # NixOS system configuration
  hosts/        # Per-machine configs
  modules/      # Shared modules between hosts
config/         # User dotfiles
  nvim/
  zsh/
  ...
```

## Usage

```sh
# Rebuild system
sudo nh os switch
```

```sh
# Symlink dotfiles
./config/stow.sh
```
