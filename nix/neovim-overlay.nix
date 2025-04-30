# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  mkNvimPlugin = pname: src: buildInputs:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src buildInputs;
      version = src.lastModifiedDate;
    };

  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  core-plugins = with pkgs.vimPlugins; [
    # treesitter
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
    nvim-ts-context-commentstring
    playground
    # completion
    luasnip
    blink-cmp
    # git
    gitsigns-nvim
    vim-fugitive
    (mkNvimPlugin "git-worktree" inputs.git-worktree-nvim [plenary-nvim])
    # misc
    telescope-nvim
    undotree 
    oil-nvim
    conform-nvim
    vim-tmux-navigator
    direnv-vim
    mini-statusline
    gruvbox-nvim
    vim-startuptime
  ];

  opt-plugins = with pkgs.vimPlugins; [
    {
      plugin = typst-vim;
      optional = false;
    }
    {
      plugin = (mkNvimPlugin
        "typstar"
        inputs.typstar
        [luasnip nvim-treesitter-parsers.typst]
      );
      optional = true;
    }
    {
    plugin = (mkNvimPlugin
      "jupynium"
      inputs.jupynium
      []
      );
      optional = true;
    }
  ];

  extraPackages = [
    pkgs.ripgrep # for telescope
  ];
in {
  nvim-pkg = mkNeovim {
    plugins = core-plugins ++ opt-plugins;
    inherit extraPackages;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = core-plugins;
  };
}
