{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btop-rocm
    fastfetch
    qmk
  ];

  hardware.keyboard.qmk.enable = true;
}
