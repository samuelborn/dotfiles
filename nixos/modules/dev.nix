{ pkgs, ... }: {

  programs.git = {
    enable = true;
    config = {
      user.name = "Samuel Born";
      user.email = "samuelborn@outlook.de";
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autoStash = true;
      gpg.format = "ssh";
      user.signingKey = "~/.ssh/id_ed25519.pub";
      commit.gpgSign = true;
      tag.gpgSign = true;
    };
  };

  environment.systemPackages = with pkgs; [
    btop-rocm
    cloc
    curl
    delta
    fastfetch
    fd
    imagemagick
    lazygit
    neovim
    qmk
    ripgrep
    stow
    tldr
    trash-cli
    tree
    _7zz
    uv
    wl-clipboard

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
