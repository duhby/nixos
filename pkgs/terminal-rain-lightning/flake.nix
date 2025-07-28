{
  description = "Flake for terminal-rain-lightning";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        python-pkg = pkgs.python3Packages.buildPythonPackage rec {
          pname = "terminal-rain-lightning";
          version = "0.1.0";
          format = "pyproject";

          src = pkgs.fetchFromGitHub {
            owner = "rmaake1";
            repo = "terminal-rain-lightning";
            rev = "b7199c634d6d38cfd546700b63acd6e746fc565c";
            sha256 = "sha256-IwXgxiofTvYUT/r5lG2BZrA/jKcHq+euonc+aCVCnF4=";
          };

          propagatedBuildInputs = with pkgs.python3Packages; [
            setuptools
          ];

          meta = with pkgs.lib; {
            description = "Terminal-based ASCII rain and lightning animation.";
            mainProgram = "terminal-rain";
            homepage = "https://github.com/rmaake1/terminal-rain-lightning";
            license = licenses.mit;
            maintainers = [];
          };
        };
      in {
        packages.default = python-pkg;

        devShells.default = pkgs.mkShell {
          buildInputs = [ python-pkg ];
        };
      }
    );
}

