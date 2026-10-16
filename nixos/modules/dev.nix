{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    btop-rocm
    cloc
    delta
    fastfetch
    fd
    git
    imagemagick
    claude-code
    lazygit
    neovim
    qmk
    ripgrep
    stow
    tldr
    tmux
    trash-cli
    tree
    _7zz
    uv

    cargo
    clang
    llvmPackages.clang-tools
    lua-language-server
    prettierd
    python3
    ruff
    rust-analyzer
    rustc
  ];

  hardware.keyboard.qmk.enable = true;
}
