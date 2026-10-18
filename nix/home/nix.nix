{
  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/born/dotfiles";
  };

  nix.settings.auto-optimise-store = true;

  programs.nix-ld.enable = true;
}
