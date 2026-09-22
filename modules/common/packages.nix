{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

	environment.systemPackages =
		with pkgs;
		[
			curl
			wget
			git
			ripgrep
			vim
			htop
			jq
			fd
			unzip
			zip
			which
			fastfetch
      eza
      pbzip2
      bat
      parallel
      
		]
		++ lib.optionals (pkgs ? luke) [ pkgs.luke ];
}
