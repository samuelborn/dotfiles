{ config, pkgs, ... }:
{
  imports = [
    ./macos-defaults.nix
    ./homebrew.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Determinate Nix owns the daemon and /etc/nix/nix.conf; nix-darwin's nix.* options are off.
  # Its daemon collects garbage on its own, so there is no nix.gc here.
  determinateNix = {
    enable = true;
    # written to /etc/nix/nix.custom.conf
    customSettings = {
      # trusted users may use flake-declared substituters (e.g. the Ayumi cache in ~/os)
      trusted-users = [
        "root"
        config.system.primaryUser
      ];
    };
  };

  # Zscaler re-signs TLS with this corporate CA, so nix and its tools must trust it.
  security.pki.certificateFiles = [ ./zscaler.pem ];
  # Tools that ignore the macOS keychain read the CA bundle from these (system CAs + zscaler.pem).
  environment.variables =
    let
      bundle = "/etc/ssl/certs/ca-certificates.crt";
    in
    {
      SSL_CERT_FILE = bundle;
      CURL_CA_BUNDLE = bundle;
      GIT_SSL_CAINFO = bundle;
      REQUESTS_CA_BUNDLE = bundle;
      PIP_CERT = bundle;
      AWS_CA_BUNDLE = bundle;
      NODE_EXTRA_CA_CERTS = bundle;
      # for `nh darwin switch`
      NH_DARWIN_FLAKE = "/Users/${config.system.primaryUser}/dotfiles#Borns-MacBook-Pro";
    };

  system.primaryUser = "Samuel.Born";

  security.pam.services.sudo_local.touchIdAuth = true;
  # pam_reattach lets Touch ID work inside tmux
  security.pam.services.sudo_local.reattach = true;

  environment.systemPackages = with pkgs; [
    coreutils
    aerospace
    btop
    nh
    glab
    qmk # macOS needs no udev rules, unlike hardware.keyboard.qmk on NixOS
    dos2unix # required by `qmk doctor`
  ];

  # not services.aerospace: it forces a generated --config-path, ignoring ~/.config/aerospace
  launchd.user.agents.aerospace = {
    command = "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };

  # SwiftBar comes from Homebrew; its plugin lives in config/swiftbar
  system.defaults.CustomUserPreferences."com.ameba.SwiftBar".PluginDirectory =
    "/Users/${config.system.primaryUser}/.config/swiftbar";
  launchd.user.agents.swiftbar = {
    command = "/Applications/SwiftBar.app/Contents/MacOS/SwiftBar";
    serviceConfig.RunAtLoad = true;
  };

  system.stateVersion = 6;
}
