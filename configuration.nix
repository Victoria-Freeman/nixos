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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-rc-lto;

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
  hardware.nvidia.open = false;
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1@0:0:0";
    amdgpuBusId = "PCI:5@0:0:0";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = false;
      };
    };

  };

  hardware.usb-modeswitch.enable = true;

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  time.timeZone = "Europe/Amsterdam";

  services.xserver.enable = true;

  services.power-profiles-daemon.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.xserver.xkb.options = "caps:super";

  # services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.groups.vend = {};
  users.users.vend = {
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
  programs.fish.enable = true;
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
  };
  services.flatpak.enable = true;
  services.lact.enable = true;
  services.envfs.enable = true;

  environment.variables.EDITOR = "nvim";

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
      nvidia-container-toolkit
      nvidiaCtkPackages.nvidia-container-toolkit-docker
      onlyoffice-desktopeditors
      ayugram-desktop
      scx.full
      nodejs_24
      bun
      gcc
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
      kdePackages.plasma-browser-integration
      kdePackages.gwenview
      kdePackages.ark
      scrcpy
      nil
      jdk25_headless
      wl-clipboard
      prismlauncher
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
