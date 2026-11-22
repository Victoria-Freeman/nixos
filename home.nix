{
  inputs,
  config,
  pkgs,
  ...
}: {
  home.username = "vend";
  home.homeDirectory = "/home/vend";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.zellij = {
    enable = true;
    settings = {
      show_startup_tips = false;
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    
    options = [
      "--cmd cd"
    ];
  
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user = {
        name = "Victoria Freeman";
        email = "venddair1@proton.me";
      };
      credential.helper = "libsecret";
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
    gtk2.force = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style = {
      name = "breeze";
      package = pkgs.kdePackages.breeze;
    };
  };

  programs.zed-editor = {
    enable = true;
    package = pkgs.unstable.zed-editor;
    extensions = [ "nix" ];
    userSettings = {
      theme = {
        mode = "system";
        dark = "Gruvbox Dark";
        light = "Gruvbox Light";
      };
      hour_format = "hour24";
      # vim_mode = true;
    };

  };

  programs.vscodium = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      styled-components.vscode-styled-components
      tal7aouy.icons
      esbenp.prettier-vscode
      astro-build.astro-vscode
      bradlc.vscode-tailwindcss
      svelte.svelte-vscode
      jnoortheen.nix-ide
    ];
    # profiles.default.userSettings = {
    #   "[nix]"."editor.tabSize" = 2;
    # };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls -l --color=auto";
      grep = "grep --color=auto";
    };
  };
  
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
}
