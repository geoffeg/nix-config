# Geoff's (WIP) nix config

An (experimental) nix-config using flakes and home manager.

## Useful commands:
* Run a one-off command without permanently installing it: `nix run nixpkgs#htop`
* Create new shell with temporary packages available: `nix shell nixpkgs#git nixpkgs#htop`

## Hosts:

### Lenovo T14 Gen 2 (40GB RAM, 1TB SSD)

* Disko partitioning.
  * BTRFS with subvolumes with LUKS for encryption.
  * A swap subvolume with a large swap file for hibernation.

## TODO

* SOPS/AGE encryption
* KDE configuration with home manager.