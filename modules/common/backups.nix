{ pkgs, ... }:

{
	environment.systemPackages = [ pkgs.borgbackup ];

	services.borgbackup.jobs.system = {
		paths = [
			"/home/geoffeg"
			"/etc"
			"/var/lib"
		];
		compression = "zstd,22";
		encryption = {
			mode = "repokey-blake2";
			passCommand = "cat /root/.config/borg/passphrase";
		};
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
