{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.displayManager.ly.enable = true;
  services.udisks2.enable = true;
  programs.niri.enable = true;
  
  environment.systemPackages = with pkgs; [
    brightnessctl
    wofi
  ];

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
  };

  home-manager.users.vend = { config, pkgs, ... }: {
    xdg.configFile."niri/config.kdl" = {
      source = ./config.kdl;
      force = true;
    };
  };
}
