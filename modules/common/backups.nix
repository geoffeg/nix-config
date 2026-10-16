{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.borgbackup ];

  services.borgbackup.jobs.system = {
    paths = [
      "/home/geoffeg"
      "/etc/ssh"
      "/var/lib/tailscale"
      "/var/lib/bluetooth"
    ];
    compression = "zstd,22";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.sops.secrets.borgPassphrase.path}";
    };
    environment.BORG_RSH = "ssh -i ${config.sops.secrets.borgSshKey.path} -o IdentitiesOnly=yes";
    startAt = "daily";
    prune.keep = {
      daily = 14;
      monthly = 12;
    };
    exclude = [
      "**/.cache"
      "**/Cache"
      "**/node_modules"
      "**/__pycache__"
      "**/.pytest_cache"
      "**/.mypy_cache"
      "**/.ruff_cache"
      "**/.tox"
      "**/.venv"
      "**/venv"
      "**/.npm"
      "**/.gradle/caches"
      "**/target"
      "**/dist"
      "**/.local/share/Trash"
      "**/.thumbnails"
    ];
  };
}
