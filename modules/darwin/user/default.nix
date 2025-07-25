{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.user;
in
{
  # TODO: refactor this to use the shared user module
  # options = import (lib.snowfall.fs.get-file "modules/shared/user/default.nix") {
  #   inherit config lib pkgs namespace;
  # };

  options.${namespace}.user = {
    name = mkOpt types.str "aaccardo" "The user account.";
    email = mkOpt types.str "andry93mail@gmail.com" "The email of the user.";
    fullName = mkOpt types.str "Andrea Accardo" "The full name of the user.";
    uid = mkOpt (types.nullOr types.int) 501 "The uid for the user account.";
  };

  config = {
    users.users.${cfg.name} = {
      uid = mkIf (cfg.uid != null) cfg.uid;
      shell = pkgs.zsh;
    };
  };
}
