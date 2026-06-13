# Dotfiles

Personal NixOS and application configs.

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
nh os switch
```

```sh
# Symlink dotfiles
./config/stow.sh
```
