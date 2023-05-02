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
          (with pre-commit-hooks.packages.${system}; [
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
        default = pkgs.luajitPackages.lpeg;
      };
    });
}
