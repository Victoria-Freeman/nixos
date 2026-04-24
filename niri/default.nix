{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.displayManager.ly.enable = true;
  programs.niri.enable = true;

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
  };

  xdg.mime.enable = true;
  xdg.menus.enable = true;

  environment.etc."xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  environment.systemPackages = with pkgs; [
    unstable.noctalia-shell
    grim
    slurp
    cliphist
    xwayland-satellite
  ];

  home-manager.users.vend = { config, pkgs, ... }: {
    home.file.".config/noctalia/settings.json" = {
      source = ./settings.json;
      force = true;
    };

    xdg.configFile."niri/config.kdl" = {
      source = ./config.kdl;
      force = true;
    };

    services.cliphist = {

      enable = true;

      systemdTargets = ["config.wayland.systemd.target"];

      extraOptions = [
        "-max-dedupe-search"
        "10"
        "-max-items"
        "500"
      ];
      allowImages = true;

    };
  };
}
