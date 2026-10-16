# geoffeg's (WIP) nix config

An (experimental) nix-config using flakes and home manager.

## Installation
To partition disks with disko and install NixOS all in one step:

```
sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake <flake-url>#<flake-attr> --disk <disk-name> <disk-device>
```

To just partition disks:
```
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/disk-config.nix
```

## Secrets
Secrets are stored in a separate, private repo, encrypted with sops+age. If a value secret changes, run `nix flake update secrets` to pull the latest changes.

## Useful commands:
* Run a one-off command without permanently installing it: `nix run nixpkgs#htop`
* Create new shell with temporary packages available: `nix shell nixpkgs#git nixpkgs#htop`

## Services

### Borg backups
* To create a new borg repo: `sudo BORG_RSH="ssh -i /run/secrets/borgSshKey" BORG_PASSCOMMAND="cat /run/secrets/borgPassphrase" borg init --encryption=repokey-blake2 --remote-path /usr/local/bin/borg user@host:/path.`
* To manually trigger a backup: `sudo systemctl start borgbackup-job-system.service`
* To inspect and view backup data: `sudo borg-job-system ...`
* More info at https://mich-murphy.com/backup-solutions-nixos/

## Hosts:

### Lenovo T14 Gen 2 (40GB RAM, 1TB SSD)

* Disko partitioning.
  * BTRFS with subvolumes with LUKS for encryption.
  * A swap subvolume with a large swap file for hibernation.

## TODO

* SOPS/AGE encryption
* KDE configuration with plasma manager.