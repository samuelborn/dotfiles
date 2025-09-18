# Dotfiles and Post-install Scripts

The included post-install script streamlines the setup process by installing essential software and configuring various options, such as config files (notably `nvim`), themes, shortcuts, and fonts.

- **1-packages.sh**: Configure package manager options, install crucial packages.
- **2-flatpak.sh**: Install commonly used Flatpaks.
- **3-main.sh**: Set options, configure shortcuts, and more.

## Full Setup Instructions

1. Clone this repository to your local machine:

   ```bash
   mkdir ~/Repos
   git clone --recursive https://github.com/SamuelBorn/dotfiles.git ~/Repos/dotfiles
   cd ~/Repos/dotfiles
   ```

1. Adept the scripts to fit four own needs.

1. Execute the scripts in the specified order:

   ```bash
   ./1-packages.sh
   ./2-flatpak.sh
   ./3-main.sh
   ```
