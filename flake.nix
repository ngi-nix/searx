{
  description = "(insert short project description here)";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  # Upstream source tree(s).
  inputs.searx-src = {
    url = "github:searx/searx";
    flake = false;
  };

  outputs = { self, nixpkgs, searx-src }:
    let

      # Generate a user-friendly version numer.
      version = builtins.substring 0 8 searx-src.lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f " x86_64-linux "; ... }'.
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });

    in

    {

      # A Nixpkgs overlay.
      overlay = final: prev: {
        searx = with final; poetry2nix.mkPoetryApplication rec {
          name = "searx-${version}";

          projectDir = searx-src;
          pyproject = ./pyproject.toml;
          poetrylock = ./poetry.lock;

          buildInputs = [
            python39
            git
            openssl
            python39Packages.pip
            uwsgi
            python39Packages.Babel
            python39Packages.virtualenv
            poetry
          ];

          preConfigure = ''
            mkdir -p .git # force BUILD_FROM_GIT
            ./bootstrap --gnulib-srcdir=${gnulib-src} --no-git --skip-po
          '';

          meta = {
            homepage = "https://www.gnu.org/software/hello/";
            description = "A program to show a familiar, friendly greeting";
          };
        };

      };

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system: {
        inherit (nixpkgsFor.${system}) searx;
      });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.searx);

      devShell = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        pkgs.mkShell
          {
            buildInputs = with pkgs;[
              python39
              git
              openssl
              python39Packages.pip
              uwsgi
              python39Packages.Babel
              python39Packages.virtualenv
              pkgs.poetry
            ];
          }
      );
      # TODO: figure out the module
      # A NixOS module, if applicable (e.g. if the package provides a system service).
      # nixosModules.searx =
      #   { pkgs, ... }:
      #   {
      #     nixpkgs.overlays = [ self.overlay ];

      #     environment.systemPackages = [ pkgs.searx ];

      #     #systemd.services = { ... };
      #   };

      # TODO: figure out which tests to add
      # Tests run by 'nix flake check' and by Hydra.
      # checks = forAllSystems (system: {
      #   inherit (self.packages.${system}) searx;

      #   # Additional tests, if applicable.
      #   test =
      #     with nixpkgsFor.${system};
      #     stdenv.mkDerivation {
      #       name = "hello-test-${version}";

      #       buildInputs = [ hello ];

      #       unpackPhase = "true";

      #       buildPhase = ''
      #         echo 'running some integration tests'
      #         [[ $(hello) = 'Hello, world!' ]]
      #       '';

      #       installPhase = "mkdir -p $out";
      #     };

      #   # A VM test of the NixOS module.
      #   vmTest =
      #     with import (nixpkgs + "/nixos/lib/testing-python.nix") {
      #       inherit system;
      #     };

      #     makeTest {
      #       nodes = {
      #         client = { ... }: {
      #           imports = [ self.nixosModules.hello ];
      #         };
      #       };

      #       testScript =
      #         ''
      #           start_all()
      #           client.wait_for_unit("multi-user.target")
      #           client.succeed("hello")
      #         '';
      #     };
      # });

    };
}




