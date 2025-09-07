{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
        ] (system: function nixpkgs.legacyPackages.${system});

      rev = self.shortRev or self.dirtyShortRev or "dirty";
    in
    {
      overlays.default = final: _: { deej = final.callPackage ./package.nix { inherit rev; }; };

      packages = forAllSystems (pkgs: {
        deej = pkgs.callPackage ./package.nix { inherit rev; };
        default = self.packages.${pkgs.hostPlatform.system}.deej;
      });

      devShells = forAllSystems (
        pkgs:
        pkgs.mkShell {
          buildInputs = with pkgs; [
            go
          ];
        }
      );
    };
}
