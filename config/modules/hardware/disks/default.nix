{ config, lib, ... }:

with lib;

let
  cfg = config.modules.hardware.disks;
in {
  options.modules.hardware.disks = {
    enable = mkEnableOption "Поддержка управления дисками";
    
    gui = mkOption {
      type = types.bool;
      default = false;
      description = "Включить GNOME Disks для управления дисками";
    };
  };

  config = mkIf cfg.enable {
    services.udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
    
    programs.gnome-disks.enable = cfg.gui;
  };
} 