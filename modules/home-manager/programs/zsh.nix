_:
let
  functions = builtins.readFile ./files/functions.zsh;
in
{
  zsh = {
    enable = true;
    localVariables = {
      HISTIGNORE = "pwd:ls:cd:eza:bat:z";
      EDITOR = "code --wait";
      VISUAL = "code --wait";
    };
    initContent =
      ''
        if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fi

        # Define variables for directories
        export PATH=$HOME/.local/share/bin:$HOME/.local/bin:$PATH

        # ------------ WARP Subshells --------------
        printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh"}}\x9c'
      ''
      + "\n"
      + functions
      + "\n";
    shellAliases = builtins.import ./files/aliases.nix;
  };
}
