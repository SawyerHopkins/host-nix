{ pkgs ? import <nixpkgs> {} }:

let
  scripts = import ./.scripts { inherit pkgs; };
in

assert pkgs.stdenv.isDarwin;

pkgs.mkShell {
  buildInputs = [
    pkgs.podman
    pkgs.krunkit
    pkgs.qemu
    pkgs.skopeo
  ] ++ scripts;

  shellHook = ''
    export CONTAINERS_MACHINE_PROVIDER=libkrun
  '';
}
