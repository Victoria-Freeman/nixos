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
      markdown.enable = true;


    };
   
    clipboard = {
      enable = true;
      providers.wl-copy.enable = true;
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

    keymaps = [
      
      { key = "<A-f>"; action = "<cmd>Ex<CR>"; mode = ["n" "v"]; }
      { key = "jk";    action = "<Esc>";       mode = ["i"]; }

      # Window shenanigans
      { key = "<A-h>"; action = "<C-w>h"; mode = ["n" "v"]; }
      { key = "<A-l>"; action = "<C-w>l"; mode = ["n" "v"]; }
      { key = "<A-j>"; action = "<C-w>j"; mode = ["n" "v"]; }
      { key = "<A-k>"; action = "<C-w>k"; mode = ["n" "v"]; }

      { key = "<leader>w";  action = "<C-w>";  mode = ["n" "v"]; }
      { key = "<leader>wd"; action = "<C-w>v"; mode = ["n" "v"]; }
      { key = "<leader>ws"; action = "<C-w>s"; mode = ["n" "v"]; }

    ];
  };
}
