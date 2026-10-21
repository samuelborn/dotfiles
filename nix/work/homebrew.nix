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
    brews = [
      "container" # Apple Linux containers, used to check glibc output
    ];
    casks = [
      "ghostty"
      "eurkey-next"
      "obsidian"
      "mac-mouse-fix" # mouse side buttons as Back/Forward in Safari
      "swiftbar" # menu bar indicator for AeroSpace workspaces
    ];
  };
}
