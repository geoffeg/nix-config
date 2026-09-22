{ lib, ... }:

{
  # Home Manager symlinks packages into a new store path on every activation,
  # which breaks KDE's inotify watch on ~/share/applications, so newly added
  # desktop entries (icons, categories) don't show up until the cache is rebuilt.
  home.activation.rebuildKdeSycoca = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if [ -n "''${DBUS_SESSION_BUS_ADDRESS:-}" ] && command -v kbuildsycoca6 >/dev/null 2>&1; then
      run kbuildsycoca6 --noincremental
    fi
  '';
}
