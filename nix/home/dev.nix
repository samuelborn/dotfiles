{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btop-rocm
    clang
    fastfetch
    qmk
    trash-cli # macOS uses its own /usr/bin/trash, which Finder empties
  ];

  hardware.keyboard.qmk.enable = true;
}
