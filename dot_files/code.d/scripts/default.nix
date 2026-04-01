{ pkgs }:

[
  (import ./pm-up.nix { inherit pkgs; })
  (import ./pm-down.nix { inherit pkgs; })
  (import ./pm-destroy.nix { inherit pkgs; })
  (import ./pm-clean-ssh.nix { inherit pkgs; })
  (import ./pm-chmod-ssh.nix { inherit pkgs; })
  (import ./pm-forward-ssh.nix { inherit pkgs; })
  (import ./pm-tunnel-ssh.nix { inherit pkgs; })
  (import ./pm-kill-ssh.nix { inherit pkgs; })
]
