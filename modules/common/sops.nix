{ inputs, ... }:

{
  sops = {
    defaultSopsFile = inputs.secrets + "/hosts/t14.yaml";

    age = {
      # automatically import host SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets = {
      tailscaleAuthKey = {
        key = "tailscale_auth_key";
      };

      borgSshKey = {
        key = "borg/ssh-private-key";
      };

      borgPassphrase = {
        key = "borg/passphrase";
      };
    };
  };
}
