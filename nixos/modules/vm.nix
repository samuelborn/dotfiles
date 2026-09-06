{ pkgs, ... }: {

  # libvirt + QEMU/KVM, the standard high-quality Linux VM stack.
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true; # TPM for Windows 11 guests
    };
  };

  # virt-manager: GUI for creating VMs and mounting ISOs.
  programs.virt-manager.enable = true;

  # Clipboard sharing / auto-resize for guests with spice-vdagent installed.
  virtualisation.spiceUSBRedirection.enable = true;

  users.users.born.extraGroups = [ "libvirtd" ];
}
