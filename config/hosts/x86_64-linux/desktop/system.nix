{ pkgs, ... }: {
  imports = [ 
    ../common/system.nix
    ./modules
  ];

  # Мы наследуемся от общей конфигурации, имейтете ввиду, что её настройки могут конфликтовать с нашими
  
  # Специфичная настройка btrfs для десктопа
  disko.devices.disk.nixos.device = "/dev/sda"; # Путь к диску для десктопа
  disko.devices.disk.nixos.content.partitions.root.content.options = [ "compress=zstd:7" "noatime" ];

  # Использование новейшего ядра Linux
  boot.kernelPackages = pkgs.master.linuxPackages_latest;
  # Автоматическая оптимизация хранилища и установка ядра в режим производительности
  nix.settings.auto-optimise-store = true;
  powerManagement.cpuFreqGovernor = "performance";

  nix.settings = {
    substituters = [
      "https://cache.garnix.io" 
      "https://hyprland.cachix.org"
      "https://nixos-cache-proxy.cofob.dev"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  environment.systemPackages = with pkgs; [
    polkit_gnome
    appimage-run
    home-manager

    kitty
    firefox
    git
  ];
}