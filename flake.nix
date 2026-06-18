{
  description = "MaelitoP's Doom Emacs configuration (nixified)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }:
    let
      eachSystem = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          packages.default = pkgs.stdenv.mkDerivation {
            name = "emacs-config";
            src = self;
            installPhase = ''
              mkdir -p $out
              cp -r * $out/
            '';
          };

          homeManagerModules = {
            emacs-config = { config, ... }: {
              home.file.".config/doom".source = self.outPath;
            };
          };
        });
    in
    flake-utils.lib.flattenTree eachSystem // {
      homeManagerModules = {
        emacs-config = { config, ... }: {
          home.file.".config/doom".source = self.outPath;
        };
      };
    };
}
