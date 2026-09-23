{ ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Weekly GC of unreferenced store paths older than 30 days.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Dedupe identical files in the store via hardlinks.
  nix.optimise.automatic = true;

  # Keep a small rollback window without allowing the boot menu to grow
  # indefinitely.
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.grub.configurationLimit = 10;
}
