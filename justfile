create:
  limactl create --name nix-test --tty=false ./tests/lima.yaml
  limactl start nix-test

clean:
  limactl stop nix-test
  limactl delete nix-test

switch:
  sudo nixos-rebuild switch --flake .#$(hostname)

update:
  nix flake update
  