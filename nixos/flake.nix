{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      modules = [ ./hosts/desktop ];
    };
    # nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
    #   modules = [ ./hosts/laptop ];
    # };
  };
}
