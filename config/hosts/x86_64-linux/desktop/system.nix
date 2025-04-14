{ pkgs, ... }: {
  imports = [ 
    ../common/system.nix
    ./modules
  ];

  # Мы наследуемся от общей конфигурации, имейтете ввиду, что её настройки могут конфликтовать с нашими

  # Включаем btrfs с настройками
  modules.fs.btrfs = {
    enable = true;
    device = "/dev/sdc"; # Путь к диску для десктопа
    mountOptions = [
      "compress=zstd:7"  # Алгоритм сжатия и уровень
      "noatime"          # Отключение обновления времени доступа
      "space_cache=v2"   # Улучшенный кэш
      "ssd"              # Оптимизации для SSD
    ];
  };

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