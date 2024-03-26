{ config, pkgs, pkgsConfig, ... }:

let
  wmConfig = pkgs.substituteAll { 
    src=./config/awesome/rc.lua; 
    terminalCmd = config.terminalCmd; 
    editor = pkgsConfig.editor;
  };
in
  {
    services.xserver = {
      enable = true;

      displayManager = {
        lightdm.enable = true;
	    defaultSession = "none+awesome";
      };

      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks
        ];
      };
    };

    services.picom = {
      enable = true;
      settings = {
        vsync = true;
        detect-client-opacity = true;
      };
    };

    programs = {
      nm-applet.enable = true;
    };
    
    environment.etc."xdg/awesome/rc.lua".source = wmConfig;
    environment.etc."xdg/awesome/themes/catppuccin".source = ./themes/awesome/catppuccin;
  }

