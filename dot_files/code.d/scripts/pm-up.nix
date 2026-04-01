{ pkgs }:

pkgs.writeShellScriptBin "pm-up" ''
  name="''${1:-$(basename "$(pwd)")}"
  image="''${2:-localhost/pm-dev:latest}"
  sock="''${3:-/tmp/podman-ssh.sock}"
  podman=${pkgs.podman}/bin/podman

  state=$($podman inspect --format '{{.State.Status}}' "$name" 2>/dev/null)

  if [ "$state" = "running" ]; then
    echo "Exec into running container: $name"
    $podman exec -it "$name" bash
  elif [ -n "$state" ]; then
    echo "Starting stopped container: $name"
    $podman start "$name"
    $podman exec -it "$name" bash
  else
    echo "Creating container: $name"
    $podman build -t pm-dev:latest https://github.com/SawyerHopkins/podman-ts-dev.git
    $podman run -dit \
      --name "$name" \
      -v "$sock:$sock" \
      -v "$(pwd):/workspaces/" \
      -e SSH_AUTH_SOCK="$sock" \
      --security-opt label=disable \
      "$image" sleep infinity
    $podman exec -it "$name" bash
  fi
''

