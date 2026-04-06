{ config, lib, pkgs, ... }:

let
  # ----------------------------------------------------------------------
  # Firmware for AIC8800DC – extracted from local source tree
  # ----------------------------------------------------------------------
  aic8800-firmware = pkgs.stdenv.mkDerivation {
    pname = "aic8800-firmware";
    version = "local";
    src = ./AIC8800/fw/aic8800DC;                # adjust path if needed
    dontBuild = true;
    installPhase = ''
      mkdir -p "$out/lib/firmware/aic8800DC"
      cp -v ./* "$out/lib/firmware/aic8800DC/"
    '';
  };

  # ----------------------------------------------------------------------
  # aic8800 kernel modules – built with clang to match your CachyOS kernel
  # ----------------------------------------------------------------------
  aic8800-modules = pkgs.stdenv.mkDerivation rec {
    pname = "aic8800";
    version = "local";
    src = ./AIC8800;                             # root of driver source

    # Use standard stdenv but override CC to clang via makeFlags.
    # The kernel's moduleBuildDependencies provide the necessary tools.
    nativeBuildInputs = config.boot.kernelPackages.kernel.moduleBuildDependencies;

    preBuild = "cd drivers/aic8800";             # enter driver subdirectory

    # --------------------------------------------------------------------
    # Force clang and LLVM toolchain for out‑of‑tree module build
    # This matches how your CachyOS kernel was compiled.
    # --------------------------------------------------------------------
    makeFlags = [
      "-C" "${config.boot.kernelPackages.kernel.dev}/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/build"
      "M=$(PWD)"
    ];

    # Optional: suppress warnings, speed up build
    env.NOCONFIG = 1;
    enableParallelBuilding = true;

    installPhase = ''
      runHook preInstall
      local moddir="$out/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/kernel/drivers/net/wireless/aic8800"
      mkdir -p "$moddir"
      cp aic8800_fdrv/aic8800_fdrv.ko "$moddir/"
      cp aic_load_fw/aic_load_fw.ko "$moddir/"
      runHook postInstall
    '';

    meta = with lib; {
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  };
in
{
  # ----------------------------------------------------------------------
  # Kernel modules
  # ----------------------------------------------------------------------
  boot.extraModulePackages = [ aic8800-modules ];
  boot.kernelModules = [ "aic_load_fw" "aic8800_fdrv" ];

  # ----------------------------------------------------------------------
  # Firmware – automatically linked to /run/current-system/sw/lib/firmware
  # ----------------------------------------------------------------------
  hardware.firmware = [ aic8800-firmware ];

  # ----------------------------------------------------------------------
  # USB mode switching – turn the dongle from storage into Wi‑Fi mode
  # ----------------------------------------------------------------------
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="a69c", ATTRS{idProduct}=="5721", \
      RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v a69c -p 5721 -M '5553424312345678000000000000061b000000020000000000000000000000'"
  '';
  systemd.tmpfiles.rules = [
    "L+ /lib/firmware - - - - /run/current-system/sw/lib/firmware"
  ];
  # Ensure usb_modeswitch is available (udev rule needs it)
  environment.systemPackages = [ pkgs.usb-modeswitch ];
}
