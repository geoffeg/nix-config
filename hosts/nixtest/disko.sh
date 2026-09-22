#!/bin/sh
curl 192.168.86.254:8000/disko-config.nix -o disko.nix
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount disko.nix