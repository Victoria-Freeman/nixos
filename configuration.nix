# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  zramSwap.enable = true;
  zramSwap.memoryPercent = 200;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #   specialisation = {
  #     LTS = {
  #       inheritParentConfig = true;
  #       configuration = {
  #         boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
  #         system.nixos.tags = [ "lts" ];
  #       };
  #     };
  #   };

  #boot.kernelPackages = pkgs.linuxPackages;
#   boot.kernelPackages = pkgs.unstable.linuxPackages;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-rc-lto;
#   boot.kernelPackages = pkgs.linuxPackages_zen;
  #boot.kernelPackages = pkgs.linuxKernel.packages.linux_testing;

  # Binary for cachyosKernels
  nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
  services.xserver.videoDrivers = ["amdgpu" "nvidia"];
  #   services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
#   hardware.nvidia.package = pkgs.unstable.linuxPackages.nvidiaPackages.vulkan_beta;
#   hardware.nvidia.package = pkgs.unstable.linuxPackages.nvidiaPackages.latest;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
  #hardware.nvidia.powerManagement.enable = true;
  #hardware.nvidia.modesetting.enable = true;

  hardware.nvidia.prime = {
    #     offload = {
    #       enable = true;
    #       enableOffloadCmd = true;
    #     };

    nvidiaBusId = "PCI:1@0:0:0";
    amdgpuBusId = "PCI:5@0:0:0";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };

  };

  hardware.usb-modeswitch.enable = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];


  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.power-profiles-daemon.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # Enable the GNOME Desktop Environment.
  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.desktopManager.mate.enable = true;
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;
  #programs.niri.enable = true;
  #security.polkit.enable = true; # polkit
  #services.gnome.gnome-keyring.enable = true; # secret service

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  services.xserver.xkb.options = "caps:super";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.groups.vend = {};
  users.users.vend = {
    #shell = pkgs.zsh;
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = ["wheel" "vend"];
  };
  programs.ccache.enable = true;
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };
  programs.adb.enable = true;
  programs.dconf.enable = true;
  #programs.nix-ld.enable = true;
  #programs.zsh = {
  #  enable = true;
  #  enableCompletion = true;
  #  autosuggestions.enable = true;
  #  syntaxHighlighting.enable = true;
  #  ohMyZsh = {
  #    enable = true;
  #    #plugins = ["copyfile"];
  #    theme = "bira";
  #  };
  #};
  programs.fish.enable = true;
  #   programs.mango.enable = true;
  #security.rtkit.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      kdePackages.xdg-desktop-portal-kde
    ];
    config = {
      kde = {
        default = [ "kde" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
      };
    };
    config.common.default = "kde";
    #config.common.default = "gtk";
  };
  services.flatpak.enable = true;
  services.lact.enable = true;
  services.envfs.enable = true;

  environment.variables.EDITOR = "nvim";


  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages =
    with pkgs; [
      firefox
      wget
      moc
      fastfetch
      pciutils
      flatpak
      papirus-icon-theme
      bibata-cursors
      kdePackages.plasma-browser-integration
      nvidia-container-toolkit
      nvidiaCtkPackages.nvidia-container-toolkit-docker
      onlyoffice-desktopeditors
      ayugram-desktop
      scx.full
      nodejs_24
      bun
      gcc
      file-roller
      git
      tor-browser
      btop
      mpv
      ffmpeg-full
      internetarchive
      python315
      python313Packages.pip
      uv
      yt-dlp
      tor
      openvpn
      qbittorrent
      arch-install-scripts
      android-studio
      mullvad-browser
      progress
      gparted
      exfatprogs
      lact
      zellij
      alejandra
      kdePackages.kate
      kdePackages.dolphin
      kdePackages.filelight
      kdePackages.plasma-workspace
      scrcpy
      nil
      jdk25_headless
      wl-clipboard
      prismlauncher
      kdePackages.gwenview
      tree
      usbutils
      ryzenadj
      kitty
      (writeShellScriptBin "settdp" ''
      if [ -z "$1" ]; then
          echo "Usage: settdp <wattage>"
          echo "Example: settdp 25"
          exit 1
      fi

      # Calculate milliwatts (wattage * 1000)
      MILLIWATTS=$(($1 * 1000))

      # Run ryzenadj with the computed limits
      sudo ryzenadj --stapm-limit="$MILLIWATTS" --fast-limit="$MILLIWATTS" --slow-limit="$MILLIWATTS"
      '')
      lazygit
      pandoc
      texliveSmall
      wl-gammactl
      
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nvf

      fishPlugins.fzf-fish
      fishPlugins.forgit
      fzf
      fishPlugins.grc
      grc
    ];

  #   virtualisation.containers.enable = true;
  #   virtualisation = {
  #     podman = {
  #       enable = true;
  #
  #       # Create a `docker` alias for podman, to use it as a drop-in replacement
  #       dockerCompat = true;
  #
  #       # Required for containers under podman-compose to be able to talk to each other.
  #       defaultNetwork.settings.dns_enabled = true;
  #     };
  #   };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.11"; 
}
