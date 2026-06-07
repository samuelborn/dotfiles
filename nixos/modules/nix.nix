{ pkgs, ... }: {

  # --- nh (os switch) ---
  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "~/dotfiles/nixos";
  };

  # --- Store ---
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # --- Packages ---
  environment.systemPackages = with pkgs; [
    comma
  ];
}
