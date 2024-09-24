{
  description = "A Nix-flake-based Node.js development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    dojo.url = "github:knownasred/dojo-nix";
  };

  outputs = { self, nixpkgs, dojo }:
    let
      overlays = [
        (final: prev: rec {
          nodejs = prev.nodejs_18;
          pnpm = prev.nodePackages.pnpm;
          yarn = (prev.yarn.override { inherit nodejs; });
        })
      ];
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit overlays system; };
        dojo = dojo.packages.${system};
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs, dojo }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            node2nix
            nodejs
            dojo.torii
            bun
            jq
          ];

          shellHook = ''
          '';
        };
      });
    };
}
