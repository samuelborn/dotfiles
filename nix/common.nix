{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    neovim
    git
    lazygit
    stow
    ripgrep
    fd
    fzf
    zoxide
    eza
    bat
    tldr
    python3
    trash-cli
    claude-code
    cloc
    _7zz
    uv
    imagemagick
    jq
    wget
    unzip

    lua-language-server
    prettierd
    cargo
    rustc
    clang

    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];

  # ~/.zshrc sources the plugins from /run/current-system/sw/share, which only links share dirs listed here
  environment.pathsToLink = [
    "/share/zsh-powerlevel10k"
    "/share/zsh-autosuggestions"
    "/share/zsh-syntax-highlighting"
  ];

  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false; # ~/.zshrc runs compinit itself
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = false; # ~/.zshrc hooks direnv itself, before p10k's instant prompt
  };

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
}
