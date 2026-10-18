{ lib, pkgs, ... }:
{
  programs.hyprland.enable = true;

  # auto-login; tuigreet only shows after logout
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        user = "born";
        command = "start-hyprland";
      };
      default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
    };
  };

  environment.systemPackages = with pkgs; [
    waybar
    fuzzel
    mako
    hypridle
    swaybg
    hyprpicker
    cliphist
    wl-clipboard
    grim
    slurp
    satty
    libnotify
    playerctl
    ddcutil
    wlsunset

    pavucontrol
    overskride
    nautilus
    papers
    loupe
    gnome-text-editor
    gnome-calculator
    gnome-calendar
    adwaita-icon-theme
    adw-gtk3
  ];

  security.soteria.enable = true;

  # lets mako start on the first notification
  systemd.packages = [ pkgs.mako ];

  # libadwaita follows color-scheme; GTK3 apps need adw-gtk3-dark
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        monospace-font-name = "JetBrainsMono Nerd Font 10";
      };
    }
  ];

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3"; # Qt follows the GTK theme
    # exposes GNOME theme settings; without it Qt apps (e.g. nextcloud) stay light
    XDG_DATA_DIRS = [ (pkgs.glib.getSchemaDataDirPath pkgs.gsettings-desktop-schemas) ];
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    NIXOS_OZONE_WL = "1"; # Electron uses Wayland, so it stays sharp at 1.25 scale
  };

  fonts.packages = [ pkgs.adwaita-fonts ];
  fonts.fontconfig.defaultFonts.sansSerif = [ "Adwaita Sans" ];

  services.gvfs.enable = true; # trash, network shares, phones in nautilus
  services.gnome.evolution-data-server.enable = true; # gnome-calendar event storage
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false; # pulled in by gnome-keyring; not wanted

  xdg.mime.defaultApplications = {
    "inode/directory" = "org.gnome.Nautilus.desktop";
    "application/pdf" = "org.gnome.Papers.desktop";
    "text/plain" = "org.gnome.TextEditor.desktop";
  }
  // lib.genAttrs [
    "image/png"
    "image/jpeg"
    "image/gif"
    "image/webp"
    "image/svg+xml"
  ] (_: "org.gnome.Loupe.desktop");
}
