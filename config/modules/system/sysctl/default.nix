{ config, lib, ... }:

with lib;

let
  cfg = config.modules.system.sysctl;
in {
  options.modules.system.sysctl = {
    enable = mkEnableOption "Оптимизированные настройки sysctl";
  };

  config = mkIf cfg.enable {
    boot.kernel.sysctl = {
      # Улучшение производительности файловой системы
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      # Улучшение сетевой производительности
      "net.core.netdev_max_backlog" = 100000;
      "net.core.somaxconn" = 100000;
      # Буферы для TCP
      "net.ipv4.tcp_rmem" = "4096 87380 16777216";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    };
  };
} 