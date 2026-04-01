{ pkgs }:

let
  cleanSock = "${import ./pm-ssh-clean.nix { inherit pkgs; }}/bin/pm-ssh-clean";
  forwardSock = "${import ./pm-ssh-forward.nix { inherit pkgs; }}/bin/pm-ssh-forward";
  chmodSock = "${import ./pm-ssh-chmod.nix { inherit pkgs; }}/bin/pm-ssh-chmod";
in

pkgs.writeShellScriptBin "pm-ssh-tunnel" ''
  sock="''${1:-/tmp/podman-ssh.sock}"

  if pgrep -f "ssh.*-R $sock" > /dev/null 2>&1; then
    echo "Tunnel already running for $sock"
    exit 0
  fi

  ${cleanSock} "$sock"
  ${forwardSock} "$sock" > /dev/null 2>&1 & disown

  sleep 1
  ${chmodSock} "$sock"

  echo "Tunnel started in background (pid $!)"
''

