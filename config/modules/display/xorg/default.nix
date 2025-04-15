{ config, lib, ... }:

with lib;

let
  cfg = config.modules.display.xorg;
in {
  options.modules.display.xorg = {
    enable = mkEnableOption "Поддержка X.org сервера";
    
    videoDrivers = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "amdgpu" "nvidia" "intel" ];
      description = "Список видеодрайверов для использования";
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      videoDrivers = cfg.videoDrivers;
    };
  };
} 