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
    device = "/dev/disk/by-uuid/460bb26c-eccd-4b10-90d3-b18b20a4e8aa";
    fsType = "btrfs";
    options = ["noatime" "compress=zstd:3"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E68C-287D";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/3cfd4697-4313-4d54-bec3-2b27d4afe90d";
    fsType = "btrfs";
    options = ["noatime" "compress=zstd:3"];
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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
