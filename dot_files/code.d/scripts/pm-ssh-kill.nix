{ pkgs }:

pkgs.writeShellScriptBin "pm-ssh-kill" ''
  sock="''${1:-/tmp/podman-ssh.sock}"

  if pkill -f "ssh.*-R $sock"; then
    echo "Tunnel killed for $sock"
  else
    echo "No tunnel running for $sock"
  fi
''
