{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.programs.earlyoom;
in {
  options = {
    modules.programs.earlyoom.enable = mkEnableOption "Раннее завершение процессов при нехватке памяти";
  };

  config = mkIf cfg.enable {
    services.earlyoom.enable = true;
  };
}