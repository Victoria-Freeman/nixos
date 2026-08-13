{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "uas" "usbcore" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e3fd840f-f7db-407d-8210-5154135d6686";
    fsType = "ext4";
    options = ["noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/81EC-4F2D";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/6ff108c6-1568-4e9b-986f-f6e0025f8e51";
    fsType = "ext4";
    options = ["noatime"];
  };

  fileSystems."/mnt/nvme" = {
    device = "/dev/disk/by-uuid/6b3f52ce-3f9f-42cd-9303-5a1fefe6476a";
    fsType = "ext4";
    options = ["noatime"];
  };

  fileSystems."/mnt/tmpfs" = {
    device = "none";
    fsType = "tmpfs";
    options = ["size=30G"];
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
