{ config, lib, ... }:

with lib;

let
  cfg = config.modules.hardware.graphics;
in {
  options.modules.hardware.graphics = {
    enable = mkEnableOption "Поддержка графики";
    
    enable32Bit = mkOption {
      type = types.bool;
      default = true;
      description = "Включить 32-битную поддержку для графики";
    };
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = cfg.enable32Bit;
    };
  };
} 