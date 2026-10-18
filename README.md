# Dotfiles

One flake for two machines: **home** (NixOS desktop) and **work** (MacBook, nix-darwin).
Nix installs packages and sets system options. App configs are plain files, linked with stow.

## Structure

```
flake.nix         nixosConfigurations.desktop + darwinConfigurations."Borns-MacBook-Pro"
nix/
  common.nix      both machines: nix settings, shared CLI tools, nvim's LSPs, zsh plugins, fonts
  home/           NixOS desktop: hardware, Hyprland, apps, gaming, VMs
  work/           MacBook: Zscaler CA, Touch ID sudo, macOS defaults, Homebrew casks, AeroSpace
config/           stow packages, one folder per app
  stow.sh         lists which packages each machine links (picked by OS)
```

Both machines: zsh, nvim, git, ghostty, lazygit, btop, claude.
Home only: hypr, waybar, fuzzel, mako, voxtype. Work only: aerospace.

When an app needs different settings per machine, the shared package includes a second file
that a `<app>-home` or `<app>-work` package provides:

- git: `~/.config/git/config` includes `home` from git-home (email, SSH signing) or `work` from git-work (email, GitHub login through gh)

zsh handles its few Mac-only lines with `$OSTYPE` checks in the one `.zshrc`.

## Usage

```sh
nh os switch                                        # home: rebuild NixOS
nh darwin switch                                    # work: rebuild nix-darwin
nix flake update --flake ~/dotfiles                 # update everything, then rebuild
./config/stow.sh                                    # link configs; add new packages to its lists
```

Per-project toolchains: put a `flake.nix` devShell in the repo plus `.envrc` with `use flake`, then `direnv allow`.

## Mac: first run

1. Install Nix and the Xcode Command Line Tools (Homebrew needs them): `xcode-select --install`
2. Clone this repo to `~/dotfiles`.
3. Let nix-darwin take over the files it manages (it refuses to overwrite unmanaged ones):
   ```sh
   sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
   # keep /etc/nix/ca-bundle.pem until the first switch: the installer's daemon still uses it
   [ -f /etc/zshrc ] && sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
   [ -f /etc/zprofile ] && sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin
   ```
4. Bootstrap, then link the configs:
   ```sh
   sudo NIX_SSL_CERT_FILE=/etc/nix/ca-bundle.pem nix --extra-experimental-features 'nix-command flakes' \
     run nix-darwin/master#darwin-rebuild -- switch --flake ~/dotfiles
   PATH=/run/current-system/sw/bin:$PATH ~/dotfiles/config/stow.sh   # this shell predates nix-darwin's PATH
   ```
5. Machine-only stuff (Zscaler cert vars, secrets) goes in `~/.zshrc.local`, git overrides in `~/.config/git/local`.
6. Grant AeroSpace Accessibility access (System Settings → Privacy & Security → Accessibility).
   It lives in /nix/store, so re-grant after it updates.
7. Open a new terminal. Some defaults need logout/login (key repeat, Caps→Esc).

## Mac: moving over from the old home-manager setup

```sh
sudo darwin-rebuild switch --flake ~/dotfiles   # home-manager is gone from here on
# remove links left by home-manager and by older layouts of this repo, so stow can replace them
find ~ -maxdepth 4 -type l \( -lname '/nix/store/*-home-manager-files/*' -o -lname '*dotfiles/config/*' \) -print -delete
~/dotfiles/config/stow.sh
```

zsh history stays where home-manager kept it, `~/.local/state/zsh/history`.
