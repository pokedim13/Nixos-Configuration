{ config, lib, ... }:

with lib;

let
  cfg = config.modules.hardware.pipewire;
in {
  options.modules.hardware.pipewire = {
    enable = mkEnableOption "Поддержка аудио через PipeWire";
    
    lowLatency = mkOption {
      type = types.bool;
      default = false;
      description = "Включить настройки низкой задержки для аудио";
    };
    
    support32Bit = mkOption {
      type = types.bool;
      default = true;
      description = "Включить 32-битную поддержку для ALSA";
    };
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = cfg.support32Bit;
      };
      
      # Настройки низкой задержки
      extraConfig.pipewire = mkIf cfg.lowLatency {
        "92-low-latency" = {
          context.properties = {
            default.clock.rate = 48000;
            default.clock.quantum = 32;
            default.clock.min-quantum = 32;
            default.clock.max-quantum = 32;
          };
        };
      };
    };
  };
} 