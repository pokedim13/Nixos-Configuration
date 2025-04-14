{ config, lib, ... }:

with lib;

let
  cfg = config.modules.system.boot;
in {
  options.modules.system.boot = {
    enable = mkEnableOption "Настройка загрузчика";
    
    type = mkOption {
      type = types.enum [ "grub" "systemd-boot" "none" ];
      default = "grub";
      description = "Тип загрузчика для использования";
    };
    
    theme = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Путь к теме для GRUB";
    };
    
    splashImage = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Путь к фоновому изображению для GRUB";
    };
  };
  
  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.type == "grub") {
      boot.loader.grub = {
        enable = true;
        efiSupport = mkDefault true;
        efiInstallAsRemovable = mkDefault true;
        useOSProber = mkDefault true;
        theme = mkIf (cfg.theme != null) cfg.theme;
        splashImage = mkIf (cfg.splashImage != null) cfg.splashImage;
      };
    })
    
    (mkIf (cfg.type == "systemd-boot") {
      boot.loader.systemd-boot = {
        enable = true;
        consoleMode = mkDefault "auto";
      };
      boot.loader.efi.canTouchEfiVariables = mkDefault true;
    })
    
    # "none" не применяет никаких настроек загрузчика
    # Пользователь сам определяет конфигурацию загрузчика
    (mkIf (cfg.type == "none") {})
  ]);
}