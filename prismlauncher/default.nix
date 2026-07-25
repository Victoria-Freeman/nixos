{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      prismlauncher-unwrapped = prev.prismlauncher-unwrapped.overrideAttrs (oa: {
        patches = (oa.patches or []) ++ [
          ./liberty.patch
        ];
      });
    })
  ];

  environment.systemPackages = [ pkgs.prismlauncher ];
}
