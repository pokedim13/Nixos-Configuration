{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.programs.steam;
in {
  options.modules.programs.steam = {
    enable = mkEnableOption "Поддержка Steam";
    
    package = mkOption {
      type = types.package;
      default = pkgs.steam;
      defaultText = literalExpression "pkgs.steam";
      description = "Пакет Steam для использования (поддержка проброса из оверлеев)";
    };
    
    hardware = mkOption {
      type = types.bool;
      default = true;
      description = "Включить поддержку Steam-совместимого оборудования";
    };
    
    protonGE = mkOption {
      type = types.bool;
      default = true;
      description = "Установить Proton GE для улучшенной совместимости с Windows-играми";
    };
    
    protontricks = mkOption {
      type = types.bool;
      default = true;
      description = "Установить Protontricks для тонкой настройки Proton";
    };
    
    gamescope = mkOption {
      type = types.bool;
      default = true;
      description = "Включить Gamescope сессию";
    };
    
    gamemode = mkOption {
      type = types.bool;
      default = true;
      description = "Включить Gamemode для оптимизации производительности во время игр";
    };
    
    networking = mkOption {
      type = types.submodule {
        options = {
          dedicatedServer = mkOption {
            type = types.bool;
            default = true;
            description = "Открыть порты для выделенных серверов";
          };
          
          localNetworkGame = mkOption {
            type = types.bool;
            default = true;
            description = "Открыть порты для локальных сетевых игр";
          };
          
          remotePlay = mkOption {
            type = types.bool;
            default = true;
            description = "Открыть порты для Remote Play";
          };
        };
      };
      default = {};
      description = "Настройки сети для Steam";
    };
  };

  config = mkIf cfg.enable {    
    hardware.steam-hardware.enable = cfg.hardware;
    
    programs.steam = {
      enable = true;
      package = cfg.package;
      # Шрифт для поддержки различных языков
      fontPackages = with pkgs; [ source-han-sans ];
      
      # Настройки Proton
      protontricks.enable = cfg.protontricks;
      gamescopeSession.enable = cfg.gamescope;
      
      # Установка Proton GE
      extraCompatPackages = mkIf cfg.protonGE (with pkgs; [ proton-ge-bin ]);
      
      # Переадресация вызовов X11, улучшает UX
      extest.enable = true;
      
      # Настройки фаервола
      dedicatedServer.openFirewall = cfg.networking.dedicatedServer;
      localNetworkGameTransfers.openFirewall = cfg.networking.localNetworkGame;
      remotePlay.openFirewall = cfg.networking.remotePlay;
    };
    
    # Включение режима оптимизации для игр
    programs.gamemode.enable = cfg.gamemode;
  };
} 