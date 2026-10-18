{ config, ... }:
{
  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
    mutableTaps = false; # Homebrew's own git clone fails behind Zscaler
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    casks = [
      "ghostty"
      "eurkey-next"
    ];
  };
}
