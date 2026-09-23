{ ... }:

{
  programs.ssh = {
    enable = true;

    settings."*" = {
      controlMaster = "auto";
      controlPath = "~/.ssh/sockets/%C";
      controlPersist = "10m";
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
      hashKnownHosts = true;
    };
  };

  # ssh won't create the socket directory itself.
  home.file.".ssh/sockets/.keep".text = "";
}
