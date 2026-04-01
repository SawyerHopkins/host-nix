{ pkgs }:

pkgs.writeShellScriptBin "pm-destroy" ''
  name="''${1:-$(basename "$(pwd)")}"
  podman=${pkgs.podman}/bin/podman

  if $podman inspect "$name" > /dev/null 2>&1; then
    $podman rm -f "$name"
    echo "Destroyed $name"
  else
    echo "No container named $name"
  fi
''
