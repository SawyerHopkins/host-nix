{ pkgs }:

let
  cleanSock = "${import ./pm-clean-ssh.nix { inherit pkgs; }}/bin/pm-clean-ssh";
  forwardAuth = "${import ./pm-forward-ssh.nix { inherit pkgs; }}/bin/pm-forward-ssh";
in

pkgs.writeShellScriptBin "pm-tunnel-ssh" ''
  sock="''${1:-/tmp/podman-ssh.sock}"

  if pgrep -f "ssh.*-R $sock" > /dev/null 2>&1; then
    echo "Tunnel already running for $sock"
    exit 0
  fi

  ${cleanSock} "$sock" > /dev/null 2>&1
  ${forwardAuth} "$sock" > /dev/null 2>&1 &
  disown

  echo "Tunnel started in background (pid $!)"
''

