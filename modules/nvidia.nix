{ config, pkgs, modulesPath, ... }:

{
	services.xserver = {
	    enable = true;
	    videoDrivers = [ "nvidia" ]; 
	};

	hardware.graphics = {
	    enable = true;
	    enable32Bit = true;
	};

  environment.systemPackages = with pkgs; [
    nv-codec-headers
  ];

	hardware.nvidia = {

	    modesetting.enable = true;
	    powerManagement.enable = true; #without this after suspend was black screen without cursor; when true, cursor appears
	    powerManagement.finegrained = false;
	    open = false;
	    nvidiaSettings = true;
	    package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

  # Force NVIDIA ICDs & EGL vendor
  environment.variables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.i686.json";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";

    # Wayland-specific stabilization
    GBM_BACKEND = "nvidia-drm";
    __GL_VRR_ALLOWED = "1"; # optional: enable variable refresh rate if supported
  };

}
