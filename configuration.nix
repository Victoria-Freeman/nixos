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

  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
  services.xserver.videoDrivers = ["amdgpu" "nvidia"];
  hardware.nvidia.open = false;
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.bleeding_edge;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "620.73.04";
    sha256_64bit = "sha256-tfLi1dqENbMlOTBAFbib9+si/grsjNaQW3puip+bjxs=";
    sha256_aarch64 = "sha256-45QZFS3Hs9hN4tKRrfmripADVpZQqksB7pAEZaS+XkA=";
    openSha256 = "sha256-+GPU2bXC/QWZTt0eH3dTvI0bMAta1GCdU2WFI4E4LWE=";
    settingsSha256 = "sha256-Wrv0F7Eo9X/0Xv5DclI9aIe3FcRtbu9okQJuWBjL8es=";
    persistencedSha256 = "sha256-QOndl1q7veD5aB6AfEe0/K2QHR8+ftLsei/aQrUCN3Q=";
  };


  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1@0:0:0";
    amdgpuBusId = "PCI:5@0:0:0";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  networking = {
    hostName = "nixos";
    hostId = "c6184d03";
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  time.timeZone = "Europe/Amsterdam";

  services.power-profiles-daemon.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.polkit.enable = true;

  services.xserver.xkb.options = "caps:super";

  # services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.users.vend = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
  };
  programs.fish.enable = true;
  programs.localsend.enable = true;
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font Mono:size=12";
      };
    };
 
  };

  services.flatpak.enable = true;

  environment.variables.EDITOR = "fresh";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    corefonts
    carlito
  ];

  environment.systemPackages =
    with pkgs; [
      firefox
      wget
      fastfetch
      flatpak
      papirus-icon-theme
      bibata-cursors
      onlyoffice-desktopeditors
      unstable.ayugram-desktop
      gitFull
      tor-browser
      btop
      mpv
      python315
      python313Packages.pip
      uv
      arch-install-scripts
      unstable.android-studio
      gparted
      btrfs-progs
      alejandra
      kdePackages.filelight
      scrcpy
      jdk25_headless
      wl-clipboard
      usbutils
      lazygit
      wl-gammactl
      android-tools
      zip
      unzip
      vlc
      yazi
      feh
      fresh-editor
      aegisub
      unstable.ffmpeg-full
      libreoffice
      filezilla
      pavucontrol
      thunar
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
