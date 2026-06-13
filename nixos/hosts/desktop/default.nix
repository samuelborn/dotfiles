{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
    ../../modules/desktop.nix
    ../../modules/dev.nix
    ../../modules/nix.nix
    ../../modules/gaming.nix
  ];

  # --- AMD GPU ---
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # 32-bit Vulkan/OpenGL for Steam
  };
  hardware.amdgpu.initrd.enable = true;

  # --- AMD CPU ---
  hardware.cpu.amd.updateMicrocode = true;

  networking.hostName = "desktop";

  system.stateVersion = "26.05";
}
