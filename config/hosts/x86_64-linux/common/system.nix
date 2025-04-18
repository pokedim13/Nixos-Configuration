{ lib, flake, modulesPath, ... }: {
    imports = [
        "${flake.conf.overlays}/nixpkgs"
        flake.conf.modules

        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    modules.fs.btrfs = {
        enable = true;
        device = "/dev/sdc";
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Конфигурация загрузчика (GRUB по умолчанию)
    modules.system.boot.enable = lib.mkDefault true;
    modules.system.boot.type = lib.mkDefault "grub";

    # Включение модулей по умолчанию
    modules.system.gc.enable = lib.mkDefault true;
    modules.system.root.enable = lib.mkDefault true;
    modules.system.locales.enable = lib.mkDefault true;
    modules.system.network.enable = lib.mkDefault true;

    # Версия системы
    system.stateVersion = lib.mkDefault flake.conf.stateVersion; 
    time.timeZone = lib.mkDefault flake.conf.timeZone;
}