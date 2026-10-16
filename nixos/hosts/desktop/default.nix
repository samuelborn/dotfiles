{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
    ../../modules/desktop.nix
    ../../modules/hyprland.nix
    ../../modules/dev.nix
    ../../modules/nix.nix
    ../../modules/gaming.nix
    ../../modules/vm.nix
  ];

  hardware.graphics.enable = true;
  hardware.amdgpu.initrd.enable = true;

  hardware.i2c.enable = true; # ddcutil sets the monitor brightness over i2c

  networking.hostName = "desktop";

  system.stateVersion = "26.05";
}
