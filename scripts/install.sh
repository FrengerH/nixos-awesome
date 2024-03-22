#!/usr/bin/env bash

git clone https://github.com/FrengerH/nixos-awesome.git ~/nixos

cd ~/nixos

if [ ! -f /etc/nixos/vars ]; then
    sudo python scripts/install-vars.py
fi

sudo nixos-rebuild switch --flake .#$1 --impure
