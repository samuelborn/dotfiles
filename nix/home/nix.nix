{
  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/born/dotfiles";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  programs.nix-ld.enable = true;
}
