{
 description = "searx : flake";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-20.03;

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux";
buildInputs = [
    nixpkgs.python39
   nixpkgs.git
   nixpkgs.openssl
    nixpkgs.python39Packages.pip
    nixpkgs.uwsgi
    nixpkgs.python39Packages.virtualenv
    nixpkgs.poetry
   ];
 };


pkgs.poetry2nix.mkPoetryApplication {
  projectDir = ./.;
      src = pkgs.fetchgit {
        url = "https://github.com/searx/searx.git";
        rev = "ae122ea943f77600fd97556503c483dcd92e1e63";
        sha256 = "sIJ+QXwUdsRIpg6ffUS3ItQvrFy0kmtI8whaiR7qEz4=";
      };


};
  };

}
