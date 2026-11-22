{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixpkgs-unstable
  } @ inputs: let
    system = "x86_64-linux";

    unstable-overlay = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config = final.config;
      };
    };

  in {

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        {
          nixpkgs.overlays = [
            unstable-overlay
          ];
        }

        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vend = import ./home.nix;

          home-manager.extraSpecialArgs = {inherit inputs;};
        }
        ./prismlauncher
        ./niri
      ];
    };
  };
}
