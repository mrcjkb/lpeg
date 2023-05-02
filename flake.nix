{
  description = "LPeg mirror";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
  }: let
    overlay = import ./nix/overlay.nix self;
  in
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          overlay
        ];
      };

      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = self;
        hooks = {
          alejandra.enable = true;
        };
      };

      shell = pkgs.mkShell {
        name = "lpeg-devShell";
        buildInputs =
          ([
            # TODO: Figure out how to get gcc to find the lua headers.
          ])
          ++ (with pre-commit-hooks.packages.${system}; [
            alejandra
          ]);
        shellHook = ''
          ${self.checks.${system}.pre-commit-check.shellHook}
        '';
      };
    in {
      shells.default = shell;

      checks = {
        inherit pre-commit-check;
      };

      packages = {
        default = pkgs.lua51Packages.lpeg;
      };
    });
}
