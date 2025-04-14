{ config, lib, ... }:

with lib;

let
  # Путь для опции определяется структурой каталогов
  # Например: modules.system.boot
  # Настройте свой путь
  cfg = config.modules.<category>.<name>;
in {
  options.modules.<category>.<name> = {
    enable = mkEnableOption "Описание функциональности модуля";
    
    # Дополнительные опции модуля
    # param1 = mkOption {
    #   type = types.str;
    #   default = "";
    #   description = "Описание параметра";
    # };
  };

  config = mkIf cfg.enable {
    # Здесь ваши настройки системы, которые применятся
    # только если модуль включен (cfg.enable = true)
  };
} 