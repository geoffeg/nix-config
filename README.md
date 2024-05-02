# nix-config

Based on [EmergentMind's Nix Configs](https://github.com/EmergentMind/nix-config/tree/dev/home/ta/common/core).

Layout:
```
nix-config/
├-- README.md        # You are here.
├-- flake.nix        # Main NixOS flake
├-- flake.lock       # Flake lock file
├-- home-manager/    # Home-manager configs. Basically stuff that's not part of the whole system
|   ├-- home.nix     # Main home-manager config
|   ├-- lore/        # User config for lore 
|   └-- tmux.nix     # Config for tmux
├-- hosts/           # Nix/NixOS configs, system-wide configurations.
    ├-- common/      # NixOS configs common for all hosts
    └-- lore/        # NixOS configs for Lore
```
