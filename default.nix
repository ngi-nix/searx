{ nixpkgs, ...}:
let pkgs = import nixpkgs {system = "x86_64-linux";};
in
pkgs.poetry2nix.mkPoetryApplication {
  projectDir = ./.;
      src = pkgs.fetchgit {
        url = "https://github.com/searx/searx.git";
        rev = "ae122ea943f77600fd97556503c483dcd92e1e63";
        sha256 = "sIJ+QXwUdsRIpg6ffUS3ItQvrFy0kmtI8whaiR7qEz4=";
      };

  buildInputs = [
    pkgs.python39
    pkgs.git
    pkgs.openssl
    pkgs.python39Packages.pip
    pkgs.uwsgi
    pkgs.python39Packages.virtualenv
    pkgs.poetry
   ];


}
