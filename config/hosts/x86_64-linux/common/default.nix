{ inputs, flake, ... }: {
  hostname = "common";
  modules = [
    ./system.nix
  ];
}