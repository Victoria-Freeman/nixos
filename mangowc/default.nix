{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.mangowm.nixosModules.mango
#     nputs.noctalia.homeModules.default
  ];

  services.displayManager.ly.enable = true;
  programs.mango.enable = true;

  environment.etc."mango/config.conf" = {
    source = ./config.conf;
  };

  environment.systemPackages = [
    pkgs.unstable.noctalia-shell
  ];

  home-manager.users.vend = { config, pkgs, ... }: {
    #home.file.".config/mango/config.conf".text = builtins.readFile ./config.conf;
    home.file.".config/noctalia/settings.json".source = ./settings.json;
  };
}
