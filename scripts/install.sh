#!/usr/bin/env bash

set -e
set -o pipefail

system=$1

while [ $# -gt 0 ]; do
    case $1 in
        # handle options
        --full) # Handle the --full flag
            if [ -f /etc/nixos/vars ]; then
                sudo rm /etc/nixos/vars  
            fi
        ;;
    esac
    shift
done

if [ ! -d ~/nixos ]; then
    git clone https://github.com/FrengerH/nixos-awesome.git ~/nixos
    cd ~/nixos
else
    cd ~/nixos
    git pull
fi

if [ ! -f /etc/nixos/vars ]; then
    nix-shell -p python3 --command "sudo python scripts/install-vars.py"
fi

NIXPKGS_ALLOW_UNFREE=1 sudo nixos-rebuild switch --flake .#$system --impure
