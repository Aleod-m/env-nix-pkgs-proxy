{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let ful = flake-utils.lib; in {
    lib = rec {
      inherit (ful) mkApp meld flattenTree simpleFlake;
      systems = ful.system;
      mkFlake = { forSystems ? systemSets.default, perSystem ? {...}: {}, generic ? {...}: {} }:
      let 
        add_pined_pkgs = fulFn:
          (flakeFn: 
            fulFn (system: 
                flakeFn { inherit system; pkgs = nixpkgs.legacyPackages.${system}; }
            )
          );
        gen = add_pined_pkgs (ful.eachSystem forSystems);
        genPassThrough = add_pined_pkgs (ful.eachSystemPassThrough forSystems);
      in
        (gen perSystem) // (genPassThrough generic);

      systemSets = rec {
        all = ful.allSystems;
        default = ful.defaultSystems;
      };
    };
  };
}
