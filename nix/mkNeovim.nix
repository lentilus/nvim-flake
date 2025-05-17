{ pkgs
, lib
, stdenv
, pkgs-wrapNeovim ? pkgs
}:

with lib;

{
  appName                ? null
, neovim-unwrapped       ? pkgs-wrapNeovim.neovim-unwrapped
, plugins                ? [ ]
, devPlugins             ? [ ]
, ignoreConfigRegexes    ? [ ]
, extraPackages          ? [ ]
, extraLuaPackages       ? p: [ ]
, extraPython3Packages   ? p: [ ]
, withPython3            ? true
, withRuby               ? false
, withNodeJs             ? false
, withSqlite             ? true
, viAlias                ? appName == null || appName == "nvim"
, vimAlias               ? appName == null || appName == "nvim"
}:

let
  defaultPlugin = { plugin = null; config = null; optional = false; runtime = { }; };

  normalizedPlugins =
    map (x: defaultPlugin // (if x ? plugin then x else { plugin = x; }))
        plugins;

  neovimConfig = pkgs-wrapNeovim.neovimUtils.makeNeovimConfig {
    inherit extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
    plugins = normalizedPlugins;
  };

  # nvim directory (init.lua, plugin/, after/, …)
  cfgSrcRaw = ../nvim;

  cfgSrcClean = lib.cleanSourceWith {
    src    = cfgSrcRaw;
    name   = "nvim-config-src";
    filter = path: _type:
      let srcPrefix = toString cfgSrcRaw + "/";
          rel       = lib.removePrefix srcPrefix (toString path);
      in  lib.all (re: builtins.match re rel == null) ignoreConfigRegexes;
  };

  # Install the config to $out/config so we can set XDG_CONFIG_HOME there.
  cfgDerivation = stdenv.mkDerivation {
    name = "nvim-user-config";
    src  = cfgSrcClean;
installPhase = ''
  mkdir -p $out/nvim
  cp -rT $src $out/nvim
'';
  };

  externalPackages = extraPackages ++ (optionals withSqlite [ pkgs.sqlite ]);

  extraWrapperArgs = lib.concatStringsSep " " (
    optional (appName != "nvim" && appName != null && appName != "")
      ''--set NVIM_APPNAME "${appName}"''

    ++ optional (externalPackages != [])
      ''--prefix PATH : "${lib.makeBinPath externalPackages}"''

    ++ optional withSqlite
      ''--set LIBSQLITE_CLIB_PATH "${pkgs.sqlite.out}/lib/libsqlite3.so"''
    ++ optional withSqlite
      ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.so"''
    
    # Upstream sourcing logic: just tell Neovim where the config lives.
    ++ [ ''--set XDG_CONFIG_HOME "${cfgDerivation}"'' ]
  );

  luaPkgs = neovim-unwrapped.lua.pkgs;
  resolvedExtraLuaPkgs = extraLuaPackages luaPkgs;

  extraWrapperLuaC = optionalString (resolvedExtraLuaPkgs != [])
    ''--suffix LUA_CPATH ";" "${lib.concatMapStringsSep ";" luaPkgs.getLuaCPath resolvedExtraLuaPkgs}"'';

  extraWrapperLua   = optionalString (resolvedExtraLuaPkgs != [])
    ''--suffix LUA_PATH ";" "${lib.concatMapStringsSep ";" luaPkgs.getLuaPath resolvedExtraLuaPkgs}"'';

  nvimWrapped =
    pkgs-wrapNeovim.wrapNeovimUnstable neovim-unwrapped (neovimConfig // {
      # No luaRcContent injection → use upstream runtimepath logic.
      wrapperArgs =
        lib.escapeShellArgs neovimConfig.wrapperArgs
        + " " + extraWrapperArgs
        + " " + extraWrapperLuaC
        + " " + extraWrapperLua;
      wrapRc = false;
    });

  isCustom = appName != null && appName != "nvim";
in
  nvimWrapped.overrideAttrs (oa: {
    buildPhase = oa.buildPhase
      + lib.optionalString isCustom ''
        mv $out/bin/nvim $out/bin/${lib.escapeShellArg appName}
      '';
    meta.mainProgram = if isCustom then appName else oa.meta.mainProgram;
  })
