{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;

  zramSwap.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_IE.UTF-8";
  i18n.extraLocaleSettings.LC_MESSAGES = "en_US.UTF-8";

  users.users.born = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "input" # voxtype reads the keyboard for its push-to-talk key
    ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;
}
