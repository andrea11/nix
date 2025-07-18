{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption types;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.user;
  # inherit (config.snowfallorg.user) name;

  home-directory =
    if cfg.name == null then
      null
    else if pkgs.stdenv.hostPlatform.isDarwin then
      "/Users/${cfg.name}"
    else
      "/home/${cfg.name}";
in
{
  ${namespace}.user = {
    enable = mkEnableOption "user account configuration.";
    email = mkOpt types.str "andry93.mail@gmail.com" "The email of the user.";
    fullName = mkOpt types.str "Andrea Accardo" "The full name of the user.";
    home = mkOpt (types.nullOr types.str) home-directory "The user's home directory.";
    icon =
      mkOpt (types.nullOr types.package) pkgs.${namespace}.user-icon
        "The profile picture to use for the user.";
    name = mkOpt (types.nullOr types.str) config.snowfallorg.user.name "The user account.";
    uid = mkOpt (types.nullOr types.int) 501 "The uid for the user account.";
  };
}
