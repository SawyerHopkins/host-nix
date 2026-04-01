{ pkgs }:

pkgs.writeShellScriptBin "pm-clean-ssh" ''
  sock="''${1:-/tmp/podman-ssh.sock}"
  port=$(${pkgs.podman}/bin/podman machine inspect --format '{{.SSHConfig.Port}}')
  user=$(${pkgs.podman}/bin/podman machine inspect --format '{{.SSHConfig.RemoteUsername}}')
  identity=$(${pkgs.podman}/bin/podman machine inspect --format '{{.SSHConfig.IdentityPath}}')
  ssh \
    -p "$port" \
    -i "$identity" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    "$user@127.0.0.1" rm -rf "$sock"
  echo "Removed $sock from machine"
''
