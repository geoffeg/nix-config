{ ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Keep a small rollback window without allowing the boot menu to grow
  # indefinitely.
  boot.loader.systemd-boot.configurationLimit = 6;
  boot.loader.grub.configurationLimit = 6;
}
