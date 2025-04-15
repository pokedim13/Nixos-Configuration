{ config, lib, ... }:

with lib;

let
  cfg = config.modules.system.zram;
in {
  options.modules.system.zram = {
    enable = mkEnableOption "Поддержка zram для виртуальной памяти";
    
    algorithm = mkOption {
      type = types.str;
      default = "lz4";
      description = "Алгоритм сжатия для zram";
    };
    
    memoryPercent = mkOption {
      type = types.int;
      default = 100;
      description = "Процент от RAM, используемый для zram";
    };
    
    priority = mkOption {
      type = types.int;
      default = 999;
      description = "Приоритет использования zram (выше будет использоваться раньше)";
    };
  };

  config = mkIf cfg.enable {
    zramSwap = {
      enable = true;
      algorithm = cfg.algorithm;
      memoryPercent = cfg.memoryPercent;
      priority = cfg.priority;
    };
  };
} 