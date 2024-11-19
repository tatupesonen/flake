{inputs, ...}: {
  imports = [
    inputs.nixvim.nixosModules.default
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    opts = {
      number = true;
      relativenumber = true;

      shiftwidth = 2;
    };

    plugins = {
      trouble.enable = true;
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          elixirls.enable = true;
          gleam.enable = true;
          gopls.enable = true;
          nixd.enable = true;
          pyright.enable = true;
        };
        keymaps.lspBuf = {
          "gd" = "definition";
          "gD" = "references";
          "gt" = "type_definition";
          "gi" = "implementation";
          "K" = "hover";
        };
      };
      rust-tools.enable = true;
      bufferline.enable = true;
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          trouble = true;
        };
      };
      lightline = {
        enable = true;
      };
      oil.enable = true;
      treesitter.enable = true;
      luasnip.enable = true;
    };
    colorschemes = {
      catppuccin.enable = true;
    };
  };
}
