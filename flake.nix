{
  description = "A very basic flake";
  inputs = {
    op-shell-plugins = {
      url = "github:1password/shell-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # Optional inputs removed
        gitignore.follows = "";
        flake-compat.follows = "";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    custom-homebrew-formulas = {
      url = "github:andrea11/homebrew-formulas";
      flake = false;
    };
    # mac-app-util = {
    #   url = "github:hraban/mac-app-util";
    # };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4vscode = {
      url = "github:nix-community/nix4vscode?ref=14635ccd0a9408b13f8e6815505ad3c1441b159c";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };
    opnix = {
      url = "github:brizzbuzz/opnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        git-hooks.follows = "git-hooks";
        home-manager.follows = "home-manager";
        # Optional inputs removed
        flake-compat.follows = "";
        nur.follows = "";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs) nix4vscode snowfall-lib treefmt-nix;

      lib = snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "setup-flake";
            title = "My custom MacOS configuration flake";
          };

          namespace = "aaccardo";
        };
      };
    in
    lib.mkFlake {
      channels-config = {
        # allowBroken = true;
        allowUnfree = true;
        # showDerivationWarnings = [ "maintainerless" ];
        permittedInsecurePackages = [ ];
      };

      overlays = [
        nix4vscode.overlays.forVscode
      ];

      homes.modules = with inputs; [
        catppuccin.homeModules.catppuccin
        inputs.op-shell-plugins.hmModules.default
        # mac-app-util.homeManagerModules.default
        nix-index-database.homeModules.nix-index
        opnix.homeManagerModules.default
        sops-nix.homeManagerModules.sops
      ];

      systems.modules = {
        darwin = with inputs; [
          # mac-app-util.darwinModules.default
          nix-homebrew.darwinModules.nix-homebrew
          (
            {
              config,
              namespace,
              ...
            }:
            {
              nix-homebrew = {
                inherit (config.${namespace}.tools.homebrew) enable;
                user = config.${namespace}.user.name;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "andrea11/homebrew-formulas" = custom-homebrew-formulas;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
          )
          sops-nix.darwinModules.sops
          stylix.darwinModules.stylix
        ];
      };

      templates = {
        default.description = "Default template";
        expo.description = "Expo template";
        next-js.description = "NextJS template";
        node.description = "Node template";
        python.description = "Python template";
        rust.description = "Rust template";
      };

      # deploy = lib.mkDeploy { inherit (inputs) self; };

      outputs-builder = channels: {
        formatter = treefmt-nix.lib.mkWrapper channels.nixpkgs ./treefmt.nix;
      };
    };
}
