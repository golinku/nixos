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

  outputs = { self, nixpkgs, stylix, home-manager, ... }: {
    nixosConfigurations = {
      nixdesk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
	    home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.aaron = import ./home.nix;
      	      backupFileExtension = "backup";
	    };
          }
        ];
      };
    };
  };
}
