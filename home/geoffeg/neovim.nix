{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
    ];

    extraConfig = ''
      set number
      set relativenumber
      set cursorline
      set ruler
      set signcolumn=yes
      set scrolloff=8
      set termguicolors
      set expandtab
      set shiftwidth=2
      set tabstop=2

      let g:airline_theme = 'dark'
      let g:airline_powerline_fonts = 1
      let g:airline#extensions#tabline#enabled = 1
    '';
  };
}
