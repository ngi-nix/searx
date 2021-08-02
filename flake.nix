{
 description = "searx : flake";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-20.03;
  buildInputs = [
      nixpkgs.python39
      nixpkgs.git
      nixpkgs.openssl
      nixpkgs.python39Packages.pip
      nixpkgs.uwsgi
      nixpkgs.python39Packages.virtualenv
      nixpkgs.poetry
     ];
 
  outputs = { self, nixpkgs }: 





nixpkgs.poetry2nix.mkPoetryApplication {
  projectDir = ./.;
      src = pkgs.fetchgit {
        url = "https://github.com/searx/searx.git";
        rev = "ae122ea943f77600fd97556503c483dcd92e1e63";
        sha256 = "sIJ+QXwUdsRIpg6ffUS3ItQvrFy0kmtI8whaiR7qEz4=";
      };


};
  

}
