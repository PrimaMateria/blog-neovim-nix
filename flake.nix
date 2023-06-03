{
  description = "My own Neovim flake";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
    neovim = {
      url = "github:neovim/neovim/stable?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    telescope-recent-files-src = {
      url = "github:smartpde/telescope-recent-files";
      flake = false;
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { self, nixpkgs, neovim, telescope-recent-files-src, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlayFlakeInputs = prev: final: {
          neovim = neovim.packages.${prev.system}.neovim;

          vimPlugins = final.vimPlugins // {
            telescope-recent-files = import ./packages/vimPlugins/telescopeRecentFiles.nix {
              src = telescope-recent-files-src;
              pkgs = prev;
            };
          };
        };

        overlayMyNeovim = prev: final: {
          myNeovim = import ./packages/myNeovim.nix {
            pkgs = prev;
          };
        };

        pkgs = import nixpkgs {
          system = system;
          overlays = [ overlayFlakeInputs overlayMyNeovim ];
        };

      in
      {
        packages = rec {
          nvim = pkgs.myNeovim;
          default = nvim;
        };

        apps = rec {
          nvim = flake-utils.lib.mkApp { drv = self.packages.${system}.nvim; };
          default = nvim;
        };
      });
}
