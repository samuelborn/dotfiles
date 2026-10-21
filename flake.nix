{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Determinate Nix on the Mac: the Ayumi .envrc wants it, and it reads Zscaler's CA from the keychain
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      determinate,
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
          determinate.darwinModules.default
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ];
      };
    };
}
