{
  description = "NixOS configuration";

  inputs = {
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
    cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    prismlauncher-unlocked = {
      url = "github:Victoria-Freeman/PrismLauncher-Unlocked/test";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nvf = {
      url = "github:notashelf/nvf";
    };

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    plasma-manager,
    mangowm,
    nixpkgs-unstable,
    cachyos-kernel,
    prismlauncher-unlocked,
    nvf
  } @ inputs: let
    system = "x86_64-linux";

    unstable-overlay = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config = final.config;
      };
    };
  in {

    packages.${system}.nvf =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./nvf-conf.nix ];
      }).neovim;

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        {
          nixpkgs.overlays = [
            unstable-overlay
            cachyos-kernel.overlays.pinned
            prismlauncher-unlocked.overlays.default
          ];
        }

        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vend = import ./home.nix;

          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.sharedModules = [
            plasma-manager.homeModules.plasma-manager
          ];
        }
        #./kde.nix
        ./mangowc
        #./cosmic.nix
        #./aic8800
        #./rtl8188gu.nix
      ];
    };
  };
}
