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

  boot.kernelPackages = pkgs.unstable.linuxPackages_testing;
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    package = pkgs.unstable.mesa;
    package32 = pkgs.unstable.pkgsi686Linux.mesa;

  };
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
  services.xserver.videoDrivers = ["amdgpu" "nvidia"];
  hardware.nvidia.open = false;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.bleeding_edge;

  hardware.nvidia.prime = {
    sync.enable = true;
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
    theme = "gruvbox-dark";
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font Mono:size=11";
      };
    };
 
  };

  services.flatpak.enable = true;

  environment.variables.EDITOR = "fresh";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
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
      corefonts
      android-tools
      zip
      unzip
      vlc
      yazi
      feh
      fresh-editor
      aegisub
      unstable.ffmpeg-full
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
