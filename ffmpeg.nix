{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      ffmpeg-full = prev.ffmpeg-full.override {
        withFdkAac = true;
        withUnfree = true;
      };
    })
  ];

  environment.systemPackages = [ pkgs.ffmpeg-full ];
}
