{ inputs, flake, ... }: {
  hostname = "desktop";
  modules = [
    ./system.nix
  ];
}