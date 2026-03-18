{ config, pkgs, stylix, ... }:

{
  imports = [
    stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

    cursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 24;
    };
  };
}

