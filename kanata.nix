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
        c d
      )

      (defalias
        c-mod (tap-hold 200 100 c lmet)
        d-mod (tap-hold 200 100 d lalt)
      )

      (deflayer base
        @c-mod
        @d-mod
      )
    '';
  };
}
