{ pkgs, lib, ... }:
{
  vim = {
    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";

    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;
    lsp.enable = true;

    languages = {
      enableTreesitter = true;

      nix.enable = true;


    };

    terminal.toggleterm = {
      enable = true;
      lazygit.enable = true;

    };

    binds = {
      whichKey.enable = true;

    };

    options = {
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
    };

  };
}
