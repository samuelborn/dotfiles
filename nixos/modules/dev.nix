{ pkgs, ... }: {

  # --- Git ---
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

  # --- Packages ---
  environment.systemPackages = with pkgs; [
    neovim
    lazygit
    ripgrep
    fd
    btop
    unzip
    curl
    tldr
    trash-cli
    cloc
    cargo
    rustc
    clang
    stow

    lua-language-server
    ruff
    rust-analyzer
    llvmPackages.clang-tools
  ];
}
