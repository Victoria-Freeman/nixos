{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.mangowm.nixosModules.mango
  ];

  services.displayManager.ly.enable = true;
  programs.mango.enable = true;

  environment.etc."mango/config.conf" = {
    source = ./config.conf;
  };

  xdg.mime.enable = true;
  xdg.menus.enable = true;

  environment.etc."xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  environment.systemPackages = with pkgs; [
    unstable.noctalia-shell
    grim
    slurp
    cliphist
  ];

  home-manager.users.vend = { config, pkgs, ... }: {
    home.file.".config/noctalia/settings.json" = {
      source = ./settings.json;
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
