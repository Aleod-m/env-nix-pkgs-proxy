# Flake utils wapper & Pining of nixpkgs.
A flake used to pin nixpkgs and add a flake utils wrapper for declaring flakes.
I use this in all my personal projects. It allows to reuse the same version of 
pakages accross my projects where reproducability is not as important.

You can also use this flake overwriting the nixpkgs input to unpin nixpkgs in order to use my wrapper around flake-utils.

The inted use for this flake is as such:
```nix
{
  inputs = {
    env-nix-pkgs-proxy.url = "github:Aleod-m/env-nix-pkgs-proxy";
    /* Your other inputs ...*/

    /* Pining an input nixpkgs to our pin 
     * <input> = {
     *   url = "...";
     *   inputs.nixpkgs.follows = "env-nix-pkgs-proxy/nixpkgs";
     * }; 
     */
  };

  outputs = { self, env-nix-pkgs-proxy, ... } @ inputs: let
    proxyLib = env-nix-pkgs-proxy.lib;
  in proxyLib.mkFlake {
    /* Wich system are supported by this flake */
    forSystems = proxyLib.systemSets.default;

    /* Flake oupts depending on the system. */
    perSystem = {pkgs, system}: {
      checks./*<SYSTEM>.*/"<CHECK>" = /* ... */;
      devShells./*<SYSTEM>.*/"<DEV_SHELL>" = /* ... */;
      packages./*<SYSTEM>.*/"<PACKAGE>" = /* ... */;
    };

    /* Flake oupts not depending on the system. */
    generic = {pkgs, system}: {
      homeConfigurations."<HOME_CONFIGURATION>" = /* ... */;
      nixosConfigurations."<NIXOS_CONFIGURATION>" = /* ... */;
    };
  });
}
```

## Library.
`lib.systems`
An attribute set of all the systems defined in nixpkgs.

`lib.systems`
An attribute set of systems set.
- `all`: All the systems defined in nixpkgs.
- `default`: `["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"]`.

```
lib.makeFlake :: {
    forSystems :: [<system>] ? lib.systemSets.default,
    perSystem :: {pkgs, system::<system>}: attrs,
    generic:: {pkgs, system:: <system>}: attrs} -> attrs
}```

Allows to generate a flake separating the system dependent outputs in the `perSystem` attribute, from system independent outputs in the `generic` attribute.
