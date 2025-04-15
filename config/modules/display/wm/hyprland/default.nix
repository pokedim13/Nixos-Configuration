{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.display.wm.hyprland;
in {
  options.modules.display.wm.hyprland = {
    enable = mkEnableOption "Поддержка Hyprland";
    
    xwayland = mkOption {
      type = types.bool;
      default = true;
      description = "Включить поддержку XWayland для запуска X11 приложений";
    };
    
    package = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "Пакет Hyprland для использования. Если null, используется стандартный пакет.";
    };
    
    portalPackage = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "Пакет xdg-desktop-portal-hyprland для использования. Если null, используется стандартный пакет.";
    };
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = cfg.xwayland;
      package = mkIf (cfg.package != null) cfg.package;
      portalPackage = mkIf (cfg.portalPackage != null) cfg.portalPackage;
    };
  };
} 