{

  description = "Nixos on my gaming desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stylix.url = "github:nix-community/stylix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, stylix, home-manager, ... }:
    let
      system = "x86_64-linux";

      mkHost = { modules, specialArgs ? {} }:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;

          modules = modules ++ [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.aaron = import ./modules/home.nix;
                backupFileExtension = "backup";
              };
            }
          ];
        };

    in {
      nixosConfigurations = {

        nixdesk = mkHost {
          modules = [
            ./hosts/desktop/configuration.nix
            ./modules/hyprland.nix
            ./modules/plasma.nix
            ./modules/stylix.nix
            ./modules/nvidia.nix
            ./modules/gaming.nix
            ./modules/flatpak.nix
            ./modules/niri.nix
          ];

          specialArgs = {
            inherit stylix;
          };
        };

        nixdeskniri = mkHost {
          modules = [
            ./hosts/desktop/configuration.nix
            ./modules/niri.nix
            ./modules/nvidia.nix
            ./modules/gaming.nix
          ]; 
        };
      };
    };
}
