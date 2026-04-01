{ pkgs }:

pkgs.writeShellScriptBin "pm-down" ''
  name="''${1:-$(basename "$(pwd)")}"
  podman=${pkgs.podman}/bin/podman

  state=$($podman inspect --format '{{.State.Status}}' "$name" 2>/dev/null)

  if [ "$state" = "running" ]; then
    echo "Stopping $name"
    $podman stop "$name"
    echo "Stopped $name"
  else
    echo "$name is not running"
  fi
''
