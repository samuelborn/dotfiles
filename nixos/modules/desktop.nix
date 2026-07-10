{ pkgs, inputs, ... }: {

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

  # --- Keyboard ---
  services.xserver.xkb.layout = "eu";

  # --- Packages ---
  environment.systemPackages = with pkgs; [
    ghostty
    nextcloud-client
    thunderbird
    signal-desktop
    chromium
    firefox
    mpv
    wl-clipboard
    inputs.voxtype.packages.${pkgs.system}.vulkan
    inputs.voxtype.packages.${pkgs.system}.osd-gtk4
  ];

  programs.ydotool = {
    group = "wheel";
    enable = true;
  };


  # --- Fonts ---
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    source-sans
    libertinus
  ];
}
