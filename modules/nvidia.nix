{ config, pkgs, ... }:

{
	hardware.graphics.enable = true;
	services.xserver.videoDrivers = [ "nvidia" ]; 

	hardware.nvidia = {

	    modesetting.enable = true;
	    powerManagement.enable = true;
	    open = false;
    };

}
