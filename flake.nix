{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: flake-utils.lib.eachDefaultSystem (system: 
  let 
    pkgs = nixpkgs.legacyPackages.${system};
  in {

    devShells.default = pkgs.mkShell {
        # All the programs i need to edit my config.
        packages = with pkgs; [
          # The nix lsp i use.
          nil
          # to run the nix flake commands.
          just
          nushell
        ];
    };
  }) // { lib.pkgs = (system: nixpkgs.legacyPackages.${system}); };
}
