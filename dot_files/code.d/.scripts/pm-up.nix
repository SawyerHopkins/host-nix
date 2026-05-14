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
    $podman build -t pm-dev:latest https://github.com/SawyerHopkins/podman-image-ts-dev.git

    port_args=""
    if [ -f .pm-ports ]; then
      while IFS= read -r line || [ -n "$line" ]; do
        line=$(echo "$line" | xargs)
        [ -z "$line" ] && continue
        case "$line" in
          *:*) port_args="$port_args -p $line" ;;
          *)   port_args="$port_args -p $line:$line" ;;
        esac
      done < .pm-ports
    fi

    $podman run -dit \
      --name "$name" \
      --userns=keep-id:uid=1000,gid=1000 \
      $port_args \
      -v "$sock:$sock" \
      -v "$(pwd):/workspaces/" \
      -e SSH_AUTH_SOCK="$sock" \
      --security-opt label=disable \
      "$image" sleep infinity
    $podman exec -it "$name" bash
  fi
''

