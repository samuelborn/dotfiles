{ pkgs, ... }: {

  # --- Boot ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.initrd.systemd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 3;
  boot.kernelParams = [
    "quiet"
    "udev.log_level=3"
  ];

  # --- Networking ---
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # --- Storage ---
  services.fstrim.enable = true;
  zramSwap.enable = true;

  # --- Locale ---
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_IE.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MESSAGES = "en_US.UTF-8";
  };

  # --- Users ---
  users.users.born = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "i2c"
    ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;

  # --- Zsh ---
  programs.zsh = {
    enable = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    interactiveShellInit = "ns() { nix shell \"nixpkgs#$1\"; }";
    shellAliases = { nd = "nix develop -c zsh"; };
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };
  environment.systemPackages = with pkgs; [ zsh-powerlevel10k ];
  programs.fzf.keybindings = true;
  programs.zoxide.enable = true;
}
