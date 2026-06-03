{
  config,
  pkgs,
  lib,
  ...
}: {
  services.kanata = {
    enable = true;
    keyboards.default.config = ''
      (defsrc
        caps
        a
        s
      )

      (defalias
        caps-mod (tap-hold 100 120 esc lmeta)
        a-mod (tap-hold-release 100 120 a lalt)
        s-mod (tap-hold-release 100 120 s lctl)
      )

      (deflayer base
        @caps-mod
        @a-mod
        @s-mod
      )
    '';
  };
}
