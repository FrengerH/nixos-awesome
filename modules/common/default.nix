{ config, pkgs, user, terminalOptions, ... }:

let

in
  {
    options = terminalOptions;

    config = {
      # isSystemUser
      fonts.packages = with pkgs; [
        fira-code
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];

      environment.etc."xdg/gtk-3.0/settings.ini" = {
        text = ''
          [Settings]
          gtk-icon-theme-name=Dracula
          gtk-theme-name=Adwaita-dark
          gtk-cursor-theme-name=Adwaita
        '';
        mode = "444";
      };

      environment.etc."xdg/user-dirs.defaults".text = ''
        DESKTOP=/home/${user}/.desktop
        DOWNLOAD=/home/${user}/downloads
        TEMPLATES=/home/${user}
        PUBLICSHARE=/home/${user}
        DOCUMENTS=/home/${user}
        MUSIC=/home/${user}
        PICTURES=/home/${user}
        VIDEOS=/home/${user}
      '';

      environment.systemPackages = with pkgs; [
        git
        wget
      ];
      
      programs = {
        firefox = import ./config/firefox{ inherit pkgs; };
      };
    };
  }
