{ pkgs, ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    extraConfig.pipewire."99-echo-cancel"."context.modules" = [
      {
        name = "libpipewire-module-echo-cancel";
        args = {
          "monitor.mode" = true;
          "source.props"."filter.smart" = true;
        };
      }
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    nextcloud-client
    thunderbird
    # electron finds no keyring on Hyprland; force libsecret so Signal's db key isn't stored in plain text
    (symlinkJoin {
      name = "signal-desktop";
      paths = [ signal-desktop ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = "wrapProgram $out/bin/signal-desktop --add-flags --password-store=gnome-libsecret";
    })
    spotify
    anki
    calibre
    brave-origin
    mpv
    qbittorrent
    libreoffice-qt-stable
    voxtype-vulkan
  ];

  systemd.user.services.voxtype = {
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.voxtype-vulkan}/bin/voxtype";
  };

  fonts.packages = with pkgs; [
    source-sans
    libertinus
  ];
}
