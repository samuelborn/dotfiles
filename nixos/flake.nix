{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      modules = [ ./hosts/desktop ];
    };
    # nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
    #   modules = [ ./hosts/laptop ];
    # };
  };
}
