{ pkgs, ... }: {

  # --- Display Manager ---
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "born";

  # --- Sound ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- Plasma ---
  services.desktopManager.plasma6.enable = true;

  # --- Packages ---
  environment.systemPackages = with pkgs; [
    ghostty
    nextcloud-client
    thunderbird
    signal-desktop
    firefox
    mpv
    wl-clipboard
  ];

  # --- Fonts ---
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    source-sans
    libertinus
  ];
}
