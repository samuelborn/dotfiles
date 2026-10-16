# Hyprland desktop that looks like GNOME. Only system bits here; app configs live in config/.
#
#   job            pick                 alternatives
#   login          greetd + tuigreet    sddm, ly, regreet
#   bar            waybar               ironbar, hyprpanel, quickshell
#   launcher       fuzzel               walker, rofi, anyrun
#   notifications  mako                 dunst, swaync, fnott
#   wallpaper      swaybg               hyprpaper, wpaperd
#   idle           hypridle             swayidle
#   clipboard      cliphist             clipse, copyq
#   screenshots    grim, slurp, satty   hyprshot, swappy
#   color picker   hyprpicker           eyedropper, gcolor3
#   brightness     ddcutil              ddcui, ddcci-driver + brightnessctl
#   night light    wlsunset             gammastep, hyprsunset
#   calendar       gnome-calendar       gsimplecal, cal in a terminal
#   sound          pavucontrol          pwvucontrol, wiremix
#   network, vpn   nmtui, nmcli         nm-connection-editor, nm-applet
#   bluetooth      overskride           blueman, bluetuith
#   polkit agent   soteria              hyprpolkitagent, polkit_gnome
#   qt theme       Qt's own gtk3 theme  qt6ct, kvantum, hyprqt6engine
{ lib, pkgs, ... }:
{
  programs.hyprland.enable = true;

  # Log in automatically. tuigreet only shows up after logging out.
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

  # mako starts with the first notification
  systemd.packages = [ pkgs.mako ];

  # libadwaita apps follow color-scheme; GTK3 apps need the adw-gtk3-dark theme
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
    QT_QPA_PLATFORMTHEME = "gtk3"; # Qt apps take colors, fonts and icons from GTK
    # lets every app read the GNOME theme settings; without it Qt apps like nextcloud stay light
    XDG_DATA_DIRS = [ (pkgs.glib.getSchemaDataDirPath pkgs.gsettings-desktop-schemas) ];
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    NIXOS_OZONE_WL = "1"; # Electron apps on Wayland, so they stay sharp at scale 1.25
  };

  fonts.packages = [ pkgs.adwaita-fonts ];
  fonts.fontconfig.defaultFonts.sansSerif = [ "Adwaita Sans" ];

  services.gvfs.enable = true; # trash, network shares and phones in nautilus
  services.gnome.evolution-data-server.enable = true; # where gnome-calendar keeps its events
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false; # comes with gnome-keyring, not wanted

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
