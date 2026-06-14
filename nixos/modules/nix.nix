{ pkgs, ... }: {

  # --- nh (os switch) ---
  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/born/dotfiles/nixos";
  };

  # --- Store ---
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # --- Packages ---
  nixpkgs.config.allowUnfree = true;

  # --- Nix-ld ---
  programs.nix-ld.enable = true;
}
