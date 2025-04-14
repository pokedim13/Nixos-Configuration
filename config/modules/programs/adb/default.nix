{ config, lib, ... }:

with lib;

let
  cfg = config.modules.programs.adb;
in {
  options.modules.programs.adb = {
    enable = mkEnableOption "Поддержка Android Debug Bridge";
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;
  };
} 