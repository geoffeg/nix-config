# Aggregates every sibling *.nix file (other than this one) for hosts to import.
{
  imports =
    let
      isModuleFile = name: name != "default.nix" && builtins.match ".*\\.nix" name != null;
      names = builtins.filter isModuleFile (builtins.attrNames (builtins.readDir ./.));
    in
    map (name: ./. + "/${name}") names;
}
