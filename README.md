# Dotfiles

NixOS flake + user configs managed with GNU Stow.

## Structure

```
nixos/          # NixOS system configuration (flake)
  hosts/        # Per-machine configs (desktop)
  modules/      # Shared modules (system, desktop, dev, gaming, nix)
config/         # User dotfiles (stow packages)
  nvim/ zsh/ ...
```

## Usage

```sh
# Rebuild system
sudo nh os switch

# Symlink dotfiles
./config/stow.sh
```
