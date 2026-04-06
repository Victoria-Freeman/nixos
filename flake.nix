{
  description = "NixOS configuration";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/6c5e707c6b53";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
#     noctalia = {
#       url = "github:noctalia-dev/noctalia-shell";
#       inputs.nixpkgs.follows = "nixpkgs-unstable";
#     };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    plasma-manager,
    mangowm,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    system = "x86_64-linux";

#     unstable-overlay = final: prev: {
#         unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};
#       };
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
          nixpkgs.overlays = [ unstable-overlay ];
        }

        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vend = import ./home.nix;

          home-manager.extraSpecialArgs = {inherit plasma-manager;};
          home-manager.sharedModules = [plasma-manager.homeModules.plasma-manager];
        }
        #./kde.nix
        ./mangowc
      ];
    };
  };
}
