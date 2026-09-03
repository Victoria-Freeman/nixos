{ config, lib, pkgs, inputs, ... }:
let
  bw = inputs.nix-bwrapper.lib.mkNixBwrapper pkgs;

  potato = pkgs.stdenv.mkDerivation {
    pname = "potato";
    version = "2.37";

    src = pkgs.fetchurl {
      url = "https://download.potato.im/linux/Potato_Desktop.2.37.tar.gz";
      hash = "sha256-tHHvsDJnXt8k1PFCPdjFdUS4vWnAprVGnmzP3F9yNUg=";
    };

    dontUnpack = true;

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

    buildInputs = with pkgs; [
      libxcb
      libx11
      libice
      dbus
      glib
      libGL
      libGLU
      expat
      gcc.cc.lib
      pulseaudio
      alsa-lib
    ];

    installPhase = ''
      mkdir -p $out/bin
      tar xzf $src Potato -C .
      cp Potato $out/bin/Potato
      chmod +x $out/bin/Potato
    '';
  };

  potatoWrapped = bw.mkBwrapper {
    imports = [ bw.bwrapperPresets.desktop ];

    app.id = "im.potato.desktop";
    app.package = potato;
    app.runScript = "Potato";
    app.env.QT_QPA_PLATFORM = "xcb";
    app.addPkgs = with pkgs; [
      libxcb
      libx11
      libice
      dbus
      glib
      libGL
      libGLU
      expat
      gcc.cc.lib
      pulseaudio
      alsa-lib
    ];

    fhsenv.performDesktopPostInstall = false;

    sockets = {
      x11 = true;
      wayland = true;
      pipewire = true;
      pulseaudio = true;
    };

    mounts.privateTmp = true;
    mounts.readWrite = [
      {
        from = "/home/vend/.potatohome";
        to = "/home/vend";
      }
      {
        from = "/mnt/tmpfs";
        to = "/mnt";
      }
    ];
  };
in
{
  environment.systemPackages = [ potatoWrapped ];
}