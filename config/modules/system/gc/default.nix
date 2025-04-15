{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.system.gc;
in {
  options.modules.system.gc = {
    enable = mkEnableOption "Сборка мусора";
  };

  config = mkIf cfg.enable {
    # Автоматическая сборка мусора
    nix.gc = {
      automatic = true;
      dates = "weekly";
    };
    
    # Исключение ненужных пакетов
    services.xserver.excludePackages = [ pkgs.xterm ];
    environment.gnome.excludePackages = [ pkgs.gnome-tour ];
    
    documentation = {
      enable = mkDefault false;
      doc.enable = mkDefault false;
      info.enable = mkDefault false;
      man.enable = mkDefault false;
      nixos.enable = mkDefault false;
    };
  };
} 