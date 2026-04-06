{
  inputs,
  config,
  pkgs,
  ...
}: {
  #   imports = [ inputs.mangowm.hmModules.mango ];

  home.username = "vend";
  home.homeDirectory = "/home/vend";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  #   xdg.configFile."mango/config.conf".source = builtins.toString ./mangowc/config.conf;

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Breeze";
      package = pkgs.kdePackages.breeze-gtk;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style = {
      name = "breeze";
      package = pkgs.kdePackages.breeze;
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      styled-components.vscode-styled-components
      tal7aouy.icons
      esbenp.prettier-vscode
      astro-build.astro-vscode
      bradlc.vscode-tailwindcss
      svelte.svelte-vscode
    ];
    # profiles.default.userSettings = {
    #   "[nix]"."editor.tabSize" = 2;
    # };
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "theme-kawasaki";
        src = pkgs.fetchFromGitHub {
          owner = "hastinbe";
          repo = "theme-kawasaki";
          rev = "5b2cda3a947afc5edff67911e0e6d3cac58be750";
          sha256 = "sha256-5Qh1XoY/kJlqv2lHaxlmukm0yavWCQHsuS5CKpiiBhM=";
        };
      }
    ];
    shellAliases = {
      ls = "ls -l --color=auto";
      grep = "grep --color=auto";
    };
    interactiveShellInit = ''
      set fish_greeting
      set -g theme_display_hostname no
      set -g theme_display_group no
      set -g theme_display_time no
      set -g theme_display_rw no
      set -gx fish_prompt_pwd_dir_length 0
    '';
  };
}
