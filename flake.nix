{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:frengerh/neovim";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, neovim, nixos-wsl, ... }: 
  let
    varsPath = /etc/nixos/vars;
    varsFile = if builtins.pathExists varsPath 
      then builtins.readFile varsPath 
      else builtins.readFile ./vars.example;
    vars = builtins.fromJSON varsFile;

    system = vars.system;
    user = vars.user;
    version = vars.version;

    pkgsConf = {
      terminal = vars.terminal or "wezterm";
      editor = vars.editor or "neovim";
    };

    supportedSystems = [ "aarch64-linux" "x86_64-linux" ];

    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    nixpkgsFor =
      forAllSystems (system: import nixpkgs { 
        inherit system; 
        config = { 
          allowUnfree = true; 
        };
      });

    lib = nixpkgs.lib;

    terminalOptions = with lib.options; {
      terminalCmd = mkOption {
        type = with lib.types; str;
        default = pkgsConf.terminal;
        description = lib.mdDoc "Command to start terminal";
      };
    };

  in
  {
    packages = forAllSystems (system:
      let 
        pkgs = nixpkgsFor.${system};
      in
      {
        default = self.packages.${system}.install;

        install = pkgs.writeShellApplication {
          name = "install";
          runtimeInputs = with pkgs; [
            git
            python3
          ];
          text = ''${./scripts/install.sh} "$@"'';
        };
      }
    );

    nixosConfigurations = {
      main = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { 
          inherit user; 
          inherit terminalOptions; 
          inherit pkgsConf;
        };
        modules = [
          /etc/nixos/configuration.nix
          /etc/nixos/hardware-configuration.nix
          ./modules/common
          ./modules/terminal/${pkgsConf.terminal}
          ./modules/wm/awesome
          neovim.nixosModules.neovim
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = {
              home.stateVersion = "${version}";
            };
          }
        ];
      };

      wsl = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { 
          pkgs = nixpkgsFor.${system};
          inherit user; 
          inherit terminalOptions; 
          inherit pkgsConf;
        };
        modules = [
          /etc/nixos/configuration.nix
          ./modules/common
          ./modules/terminal/${pkgsConf.terminal}
          neovim.nixosModules.neovim
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "${version}";
            wsl.enable = true;
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = {
              home.stateVersion = "${version}";
            };
          }
        ];
      };
    };
  };
}
