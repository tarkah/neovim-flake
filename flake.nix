{
  description = "tarkah's neovim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim-session-manager = {
      url = "github:Shatur/neovim-session-manager";
      flake = false;
    };

    rust-tools-nvim = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };
 
    lualine-nvim = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;

          overlays = [
            (_: _: {
              inherit inputs;

              writeIf = cond: msg: if cond then msg else "";
            })
          ];
        };

        neovim = pkgs.callPackage ./neovim/default.nix { };
      in
      rec {
        formatter = pkgs.nixpkgs-fmt;

        apps = rec {
          nvim = {
            type = "app";
            program = "${packages.default}/bin/nvim";
          };

          default = nvim;
        };

        packages = {
          default = neovim;
        };

        overlays = {
          default = f: p: {
            inherit neovim;
          };

          withSettings = settings: f: p: {
            neovim = neovim.override {
              inherit settings;
            };
          };
        };
      }
    );
}
