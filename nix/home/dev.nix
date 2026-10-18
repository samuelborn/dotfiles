{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btop-rocm
    clang
    fastfetch
    qmk
  ];

  hardware.keyboard.qmk.enable = true;
}
