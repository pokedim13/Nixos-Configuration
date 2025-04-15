{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.programs.dconf;
in {
  options = {
    modules.programs.dconf.enable = mkEnableOption "Enable dconf";
  };

  config = mkIf cfg.enable {
    programs.dconf.enable = true;
  };
}