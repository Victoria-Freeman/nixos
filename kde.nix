{
  config,
  pkgs,
  lib,
  ...
}: {
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa
    kdePackages.konsole
    kdePackages.discover
    kdePackages.ark
  ];

  home-manager.users.vend = {
    config,
    pkgs,
    ...
  }: {
    programs.plasma = {
      enable = true;
      workspace = {
        clickItemTo = "select";
        lookAndFeel = "org.kde.breezedark.desktop";
        cursor = {
          theme = "Bibata-Modern-Ice";
          size = 32;
        };
        iconTheme = "Papirus-Dark";
        wallpaper = "${config.home.homeDirectory}/Pictures/Wallpapers/wallhaven-42xwgm.jpg";
      };

      shortcuts = {
        "services/Alacritty.desktop" . "_launch" = "Meta+C";
        "services/com.ayugram.desktop.desktop" . "_launch" = "Meta+T";
        "services/firefox.desktop" . "_launch" = "Meta+F";
      };

      session = {
        sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
      };

      shortcuts = {
        "kwin"."Switch to Desktop 1" = "Meta+1";
        "kwin"."Switch to Desktop 2" = "Meta+2";
        "kwin"."Switch to Desktop 3" = "Meta+3";
        "kwin"."Switch to Desktop 4" = "Meta+q";
        "kwin"."Switch to Desktop 5" = "Meta+w";
        "kwin"."Switch to Desktop 6" = "Meta+e";
        "kwin"."Switch to Desktop 7" = "Meta+a";
        "kwin"."Switch to Desktop 8" = "Meta+s";
        "kwin"."Switch to Desktop 9" = "Meta+d";
        "kwin"."Switch to Desktop 10" = "Meta+z";
        "kwin"."Switch to Desktop 11" = "Meta+x";
      };

      kwin = {
        effects.desktopSwitching.animation = "off";
        virtualDesktops = {
          number = 11;
          rows = 1;
        };
      };

      panels = [
        {
          location = "bottom";
          height = 44;
          alignment = "center";
          minLength = 1600;
          maxLength = 1600;
          lengthMode = "custom";
          hiding = "dodgewindows";
          floating = true;

          widgets = [
            "org.kde.plasma.kickoff" # Application Launcher
            "org.kde.plasma.icontasks" # Task Manager
            "org.kde.plasma.systemtray" # System Tray
            "org.kde.plasma.digitalclock" # Clock
          ];
        }
      ];

      input.mice = [
        {
          name = "Rapoo Rapoo Gaming Device";
          vendorId = "24ae";
          productId = "1870";
          acceleration = -0.4;
          accelerationProfile = "none";
        }
      ];

      powerdevil = {
        AC = {
          autoSuspend = {
            action = "nothing";
          };
          whenLaptopLidClosed = "doNothing";
          powerButtonAction = "sleep";
          powerProfile = "powerSaving";
          turnOffDisplay.idleTimeout = "never";
          inhibitLidActionWhenExternalMonitorConnected = true;
        };
      };

      kscreenlocker = {
        autoLock = false;
        timeout = 0;
      };
    };
  };
}
