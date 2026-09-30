{ ... }: {
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true; # TPM for Windows 11 guests
  programs.virt-manager.enable = true;
  users.users.born.extraGroups = [ "libvirtd" ];
}
