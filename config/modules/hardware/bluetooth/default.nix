{ config, lib, ... }:

with lib;

let
  cfg = config.modules.hardware.bluetooth;
in {
  options.modules.hardware.bluetooth = {
    enable = mkEnableOption "Поддержка Bluetooth";
    
    gui = mkOption {
      type = types.bool;
      default = false;
      description = "Включить графический интерфейс Blueman для управления Bluetooth";
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    
    services.blueman.enable = cfg.gui;
  };
} 