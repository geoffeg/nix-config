{ configVars, ... }:
{
  imports = [
    common/core
    common/optional/desktops
  ];

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };
}
