# No password sudo
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER

# Install dotfiles
cd ~/Repos/dotfiles/home
stow --target=$HOME .

# Disable all ACPI wakeup triggers to fix suspend
cat << 'EOF' | sudo tee /etc/systemd/system/fix-wakeup.service
[Unit]
Description="Disable all acpi events to fix suspend + wake"

[Service]
ExecStart=/bin/sh -c "awk '/enabled/{print $1}' /proc/acpi/wakeup | while read dev; do echo $dev > /proc/acpi/wakeup; done"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable --now fix-wakeup

# Change default shell to zsh
chsh --shell /bin/zsh

# GitHub add ssh key and default sign commits
read -p "E-Mail address: " email
read -p "Full name: " name
ssh-keygen -t ed25519 -C "$email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub | wl-copy
xdg-open "https://github.com/settings/keys"
git config --global user.name "$name"
git config --global user.email "$email"
git config --global core.editor nvim
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
git config --global pull.rebase true
git config --global rebase.autoStash true
git config --global submodule.rebase true
git config --global push.recurseSubmodules on-demand
