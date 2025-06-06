{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.env;
in
{
  options.${namespace}.system.env = lib.mkOption {
    apply = lib.mapAttrs (
      _n: v: if lib.isList v then lib.concatMapStringsSep ":" toString v else (toString v)
    );
    default = { };
    description = "A set of environment variables to set.";
    type =
      with lib.types;
      attrsOf (oneOf [
        str
        path
        (listOf (either str path))
      ]);
  };

  config = {
    environment = {
      extraInit = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (n: v: ''
          export ${n}="${v}"
        '') cfg
      );

      extraOutputsToInstall = [
        "bin"
        "dev"
        "doc"
        "include"
        "info"
        "share"
      ];

      pathsToLink = [
        "/bin"
        "/doc"
        "/etc"
        "/info"
        "/share"
        "/share/doc"
        "/usr/bin"
      ];

      # TODO: Any flags that should be set?
      #   variables =
      #     let
      #       pagerArgs = [
      #         "--RAW-CONTROL-CHARS" # Only allow colors.
      #         "--wheel-lines=5"
      #         "--LONG-PROMPT"
      #         "--no-vbell"
      #         " --wordwrap" # Wrap lines at spaces.
      #       ];
      #     in
      #     {
      #       SYSTEMD_PAGERSECURE = "true";
      #       PAGER = "less -FR";
      #       LESS = lib.concatStringsSep " " pagerArgs;
      #       SYSTEMD_LESS = lib.concatStringsSep " " (
      #         pagerArgs
      #         ++ [
      #           "--quit-if-one-screen"
      #           "--chop-long-lines"
      #           "--no-init" # Keep content after quit.
      #         ]
      #       );
      #     };
    };
  };
}
