{ pkgs }:

pkgs.writeShellScriptBin "pm-ssh-forward" ''
  sock="''${1:-/tmp/podman-ssh.sock}"
  port=$(${pkgs.podman}/bin/podman machine inspect --format '{{.SSHConfig.Port}}')
  user=$(${pkgs.podman}/bin/podman machine inspect --format '{{.SSHConfig.RemoteUsername}}')
  identity=$(${pkgs.podman}/bin/podman machine inspect --format '{{.SSHConfig.IdentityPath}}')
  if [ -z "$SSH_AUTH_SOCK" ]; then
    echo "SSH_AUTH_SOCK is not set" >&2
    exit 1
  fi
  echo "Forwarding SSH_AUTH_SOCK to machine at $sock"
  ssh \
    -p "$port" \
    -i "$identity" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o ControlMaster=no \
    -o ControlPath=none \
    -o ExitOnForwardFailure=yes \
    -R "$sock:$SSH_AUTH_SOCK" \
    -N \
    "$user@127.0.0.1"
''

