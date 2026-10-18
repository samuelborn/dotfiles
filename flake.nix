{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
    }:
    {
      formatter = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        modules = [
          ./nix/common.nix
          ./nix/home
        ];
      };

      darwinConfigurations."Borns-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          ./nix/common.nix
          ./nix/work
          nix-homebrew.darwinModules.nix-homebrew
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ];
      };
    };
}
