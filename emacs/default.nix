{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
   ((emacsPackagesFor emacs-unstable-pgtk).emacsWithPackages (epkgs: [
     epkgs.gruvbox-theme
     epkgs.lsp-mode
     epkgs.vterm
     epkgs.which-key
     epkgs.tree-sitter-langs
     epkgs.nix-mode
   ]))

   ruff
   jdt-language-server
   kotlin-language-server
   nixd
   marksman
  ];

  home-manager.users.vend = { config, pkgs, ... }: {
    home.file.".emacs.d/init.el".source = ./init.el;
  };
}
