# Aggregates every sibling *.nix file (other than this one) for hosts to import.
{
  imports =
    let
      entries = builtins.readDir ./.;

      isModuleFile = name:
        name != "default.nix" && entries.${name} == "regular" && builtins.match ".*\\.nix" name != null;

      isModuleDir = name:
        entries.${name} == "directory" && builtins.pathExists (./. + "/${name}/default.nix");

      fileNames = builtins.filter isModuleFile (builtins.attrNames entries);
      dirNames = builtins.filter isModuleDir (builtins.attrNames entries);
    in
    (map (name: ./. + "/${name}") fileNames)
    ++ (map (name: ./. + "/${name}") dirNames);
}
