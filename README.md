# Geoff's (WIP) nix config

An experimental nix-config using flakes. Currently limited to a Lenovo T14 Gen 2 laptop.

## Useful commands:
* Create a new shell with a temporary command: `nix-shell -p htop`

## Hosts:

### Lenovo T14 Gen 2 (40GB RAM, 1TB SSD)

* Disko partitioning.
  * BTRFS with subvolumes with LUKS for encryption.
  * A swap subvolume with a large swap file for hibernation.

## TODO

### Home Manager
1. Setup git (user.email and user.name)

# SOPS/AGE encryption