{
    description = "sweetdogs system configuration";

    inputs = {
        # Переопределение flake схемы
        flake-parts.url = "github:hercules-ci/flake-parts";

        # Каналы обновлений
        master.url = "github:nixos/nixpkgs/master";
        unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        stable.url = "github:nixos/nixpkgs/nixos-24.11";
        nixpkgs.follows = "unstable";

        # Управление дисками
        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Управление домашними директориями
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Секреты
        sops.url = "github:Mic92/sops-nix";        

        # WM
        hyprland.url = "github:hyprwm/Hyprland";
    };

    outputs = { self, flake-parts, ... }@inputs: flake-parts.lib.mkFlake { inherit inputs; } {
        systems = ["x86_64-linux"];

        flake = {
            conf = builtins.trace "Importing config" import ./config;

            nixosConfigurations = import "${self.conf.utils}/hosts.nix" {
                inherit inputs;
                flake = self;
            };
        };
    };
}