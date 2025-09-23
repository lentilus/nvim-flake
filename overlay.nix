# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = pname: src: buildInputs:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src buildInputs;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.system};

  all-plugins = with pkgs.vimPlugins; [
    # treesitter
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
    nvim-ts-context-commentstring
    playground
    # completion
    luasnip
    blink-cmp
    (mkNvimPlugin
       "typstar"
       inputs.typstar
       [luasnip nvim-treesitter-parsers.typst])
    # git
    gitsigns-nvim
    vim-fugitive
    (mkNvimPlugin
      "git-worktree"
      inputs.git-worktree-nvim
      [plenary-nvim])
    # misc
    telescope-nvim
    undotree 
    oil-nvim
    fidget-nvim
    vim-tmux-navigator
    direnv-vim
    mini-statusline
    gruvbox-nvim
    vim-startuptime
    typst-vim
  ];

  externalPackages = with pkgs; [
    ripgrep
  ];

  defaultPlugin = {
    plugin = null;
    config = null;
    optional = false;
    runtime = {};
  };


  # Map all plugins to an attrset { plugin = <plugin>; config = <config>; optional = <tf>; ... }
  normalizedPlugins = map (x:
    defaultPlugin
    // (
      if x ? plugin
      then x
      else {plugin = x;}
    ))
  all-plugins;

    # Creates an attrset later consumed by pkgs.wrapNeovimUnstable
    neovimConfig = final.pkgs.neovimUtils.makeNeovimConfig {
      # inherit extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
      plugins = normalizedPlugins;
    };

    # the nvim directory
    config = ./nvim;

    # Split runtimepath into 3 directories:
    # - lua, to be prepended to the rtp at the beginning of init.lua
    # - nvim, containing plugin, ftplugin, ... subdirectories
    # - after, to be sourced last in the startup initialization
    # See also: https://neovim.io/doc/user/starting.html
    nvimRtp = pkgs.stdenv.mkDerivation {
      name = "nvim-rtp";
      src = config;

      buildPhase = ''
        mkdir -p $out/nvim
        mkdir -p $out/lua
        rm init.lua
      '';

      installPhase = ''
        cp -r lua $out/lua
        rm -r lua

        cp -r after $out/after
        rm -r after

        cp -r -- * $out/nvim
      '';
    };

    # The final init.lua content that we pass to the Neovim wrapper.
    # It wraps the user init.lua, prepends the lua lib directory to the RTP
    # and prepends the nvim and after directory to the RTP
    # It also adds logic for bootstrapping dev plugins (for plugin developers)
    initLua =
      ''
        -- prepend lua directory
        vim.opt.rtp:prepend('${nvimRtp}/lua')
      ''
      # Wrap init.lua
      + (builtins.readFile ./nvim/init.lua)

      # not sure if the below order is correct.
      + ''
        vim.opt.rtp:prepend('${nvimRtp}/nvim')
        vim.opt.rtp:prepend('${nvimRtp}/after')
      '';
in {
  nvim-pkg = pkgs-locked.wrapNeovimUnstable pkgs.neovim-unwrapped (neovimConfig
    // {
      luaRcContent = initLua;
      wrapperArgs =
        escapeShellArgs neovimConfig.wrapperArgs
        + " "
        + ''--prefix PATH : "${makeBinPath externalPackages}"'';
      # wrapRc = true;
  });

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };
}
