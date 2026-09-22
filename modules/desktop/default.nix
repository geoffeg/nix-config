{ ... }:
let
	dirEntries = builtins.readDir ./.;
	names = builtins.attrNames dirEntries;
	nixFiles = builtins.filter (
		name:
			dirEntries.${name} == "regular"
			&& builtins.match ".*\\.nix" name != null
			&& name != "default.nix"
	) names;
in
{
	imports = builtins.map (name: ./. + "/${name}") nixFiles;
}
