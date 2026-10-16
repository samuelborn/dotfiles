{ pkgs, ... }: {

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."99-echo-cancel"."context.modules" = [{
      name = "libpipewire-module-echo-cancel";
      args = {
        "monitor.mode" = true;
        "source.props"."filter.smart" = true;
      };
    }];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

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
    brave-origin
    mpv
    qbittorrent
    libreoffice-qt6-fresh
    voxtype-vulkan
  ];

  systemd.user.services.voxtype = {
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    path = [ pkgs.ydotool ];
    serviceConfig.ExecStart = "${pkgs.voxtype-vulkan}/bin/voxtype";
  };

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
