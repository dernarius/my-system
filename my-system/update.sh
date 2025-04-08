#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR

nix-channel --update

cp ./configuration.nix /etc/nixos/configuration.nix

# export NIXPKGS_ALLOW_BROKEN=1
nixos-rebuild switch
