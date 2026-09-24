{ pkgs, ... }:

{
  boot.kernelModules = [
    "thinkpad_acpi"
    "coretemp"
    "jc42"
  ];

  # Needed for sensors-detect's SMBus/I2C probing.
  hardware.i2c.enable = true;

  environment.systemPackages = [
    pkgs.lm_sensors
  ];

  # Generated once via `sudo sensors-detect`, then committed here so it's
  # reproducible instead of living only as untracked state in /etc.
  # environment.etc."sensors3.conf".source = ./sensors3.conf;
}
