{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.programs.kdeconnect;
in {
  options = {
    modules.programs.kdeconnect.enable = mkEnableOption "Enable kdeconnect";
  };

  config = mkIf cfg.enable {
    programs.kdeconnect.enable = true;
  };
}