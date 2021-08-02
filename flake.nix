{
 description = "searx : flake";
inputs = { nixpkgs.url = github:NixOS/nixpkgs/nixos-20.03;   };

outputs = inputs: { defaultPackage.x86_64-linux = import ./default.nix {nixpkgs =inputs.nixpkgs; }; };
  

}
