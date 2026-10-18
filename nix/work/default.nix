{ config, pkgs, ... }:
{
  imports = [
    ./macos-defaults.nix
    ./homebrew.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  # Zscaler re-signs TLS with this corporate CA, so nix and its tools must trust it.
  security.pki.certificateFiles = [ ./zscaler.pem ];

  system.primaryUser = "Samuel.Born";

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPackages = with pkgs; [
    coreutils
    aerospace
    nh
  ];

  # for `nh darwin switch` 
  environment.variables.NH_DARWIN_FLAKE = "/Users/${config.system.primaryUser}/dotfiles#Borns-MacBook-Pro";

  # not services.aerospace: it forces a generated --config-path, ignoring ~/.config/aerospace
  launchd.user.agents.aerospace = {
    command = "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };

  system.stateVersion = 6;
}
