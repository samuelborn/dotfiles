{ pkgs, inputs, ... }: {

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "born";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb.layout = "eu";

  environment.systemPackages = with pkgs; [
    ghostty
    nextcloud-client
    thunderbird
    signal-desktop
    chromium
    spotify
    anki
    calibre
    firefox
    mpv
    qbittorrent
    inputs.voxtype.packages.${pkgs.system}.vulkan
    inputs.voxtype.packages.${pkgs.system}.osd-gtk4
  ];

  programs.ydotool = {
    group = "wheel";
    enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    source-sans
    libertinus
  ];
}
