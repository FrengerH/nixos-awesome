{ config, pkgs, ... }:

let

in
  {
    users.defaultUserShell = pkgs.fish;

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

    environment.systemPackages = with pkgs; [
      wezterm
      any-nix-shell
      fzf
      xclip
      starship
      bat
      zoxide
    ];

    programs = {
      fish = import ./config/fish;
      starship = import ./config/starship{ inherit pkgs; };
      nm-applet.enable = true;
    };
    
    environment.etc."xdg/awesome/rc.lua".source = ./config/awesome/rc.lua;
    environment.etc."xdg/awesome/themes/catppuccin".source = ./themes/awesome/catppuccin;
    environment.etc."wezterm/wezterm.lua".source = ./config/wezterm/wezterm.lua;
    environment.etc."bat/themes/CatppuccinMocha.tmTheme".source = (pkgs.fetchFromGitHub
      {
        owner = "catppuccin";
        repo = "bat";
        rev = "b19bea35a85a32294ac4732cad5b0dc6495bed32"; # Replace with the latest commit hash
        sha256 = "sha256-POoW2sEM6jiymbb+W/9DKIjDM1Buu1HAmrNP0yC2JPg=";
      } + "/themes/Catppuccin Mocha.tmTheme");
  }

