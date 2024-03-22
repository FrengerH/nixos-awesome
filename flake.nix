{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:frengerh/neovim";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, neovim, ... }: 
  let
    varsPath = /etc/nixos/vars;
    varsFile = if builtins.pathExists varsPath 
      then builtins.readFile varsPath 
      else builtins.readFile ./vars.example;
    vars = builtins.fromJSON(varsFile);

    system = vars.system;
    user = vars.user;
    version = vars.version;

    supportedSystems = [ "aarch64-linux" "x86_64-linux" ];

    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    nixpkgsFor =
      forAllSystems (system: import nixpkgs { inherit system; });

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
        specialArgs = { inherit user; };
        modules = [
          /etc/nixos/configuration.nix
          /etc/nixos/hardware-configuration.nix
          ./modules/common
          ./modules/wm
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
    };
  };
}
