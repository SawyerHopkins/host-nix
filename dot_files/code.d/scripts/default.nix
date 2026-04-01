{ pkgs }:

[
  (import ./pm-up.nix { inherit pkgs; })
  (import ./pm-down.nix { inherit pkgs; })
  (import ./pm-destroy.nix { inherit pkgs; })
  (import ./pm-ssh-clean.nix { inherit pkgs; })
  (import ./pm-ssh-chmod.nix { inherit pkgs; })
  (import ./pm-ssh-forward.nix { inherit pkgs; })
  (import ./pm-ssh-tunnel.nix { inherit pkgs; })
  (import ./pm-ssh-kill.nix { inherit pkgs; })
]
