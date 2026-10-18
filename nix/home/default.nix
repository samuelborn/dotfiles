{
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ./desktop.nix
    ./hyprland.nix
    ./dev.nix
    ./nix.nix
    ./gaming.nix
    ./vm.nix
  ];

  hardware.graphics.enable = true;
  hardware.amdgpu.initrd.enable = true;

  hardware.i2c.enable = true; # ddcutil sets the monitor brightness over i2c

  networking.hostName = "desktop";

  system.stateVersion = "26.05";
}
