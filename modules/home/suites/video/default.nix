{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.${namespace}.suites.video;

in
{
  options.${namespace}.suites.video = {
    enable = lib.mkEnableOption "video configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; lib.optionals stdenv.hostPlatform.isDarwin [ iina ];

    ${namespace}.programs = {
      graphical.apps = {
        # obs = lib.mkDefault enabled;
      };
    };
  };
}
