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

gen_machine_age_key:
  sudo ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub

gen_user_age_key:
  ssh-to-age < ~/.ssh/id_ed25519.pub
  