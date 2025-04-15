{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.dev.podman;
in {
  options.modules.dev.podman = {
    enable = mkEnableOption "Поддержка контейнеров Podman";
    
    dockerCompat = mkOption {
      type = types.bool;
      default = true;
      description = "Включить совместимость с Docker CLI";
    };
    
    dockerSocket = mkOption {
      type = types.bool;
      default = true;
      description = "Создать сервис для эмуляции Docker socket";
    };
    
    autoPrune = mkOption {
      type = types.bool;
      default = true;
      description = "Автоматическая очистка неиспользуемых образов и контейнеров";
    };
    
    pruneInterval = mkOption {
      type = types.str;
      default = "weekly";
      description = "Интервал очистки неиспользуемых образов и контейнеров";
    };
    
    installCompose = mkOption {
      type = types.bool;
      default = true;
      description = "Установить podman-compose";
    };
    
    installTui = mkOption {
      type = types.bool;
      default = true;
      description = "Установить podman-tui (текстовый интерфейс)";
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        
        # Установить Docker CLI для совместимости
        dockerCompat = cfg.dockerCompat;
        
        # Настройка для автоматического созданий контейнеров без root
        defaultNetwork.settings.dns_enabled = true;
        
        # Автоматическая очистка неиспользуемых образов и контейнеров
        autoPrune = mkIf cfg.autoPrune {
          enable = true;
          dates = cfg.pruneInterval;
          flags = ["--all"];
        };
      };
      
      # Поддержка OCI контейнеров
      oci-containers.backend = "podman";
    };
    
    # Инструменты для работы с контейнерами
    environment.systemPackages = with pkgs; 
      (optionals cfg.installCompose [ podman-compose ])
      ++ (optionals cfg.installTui [ podman-tui ]);
    
    # Создание сервиса для запуска podman socket, который эмулирует docker socket
    systemd.services.podman-docker-socket = mkIf cfg.dockerSocket {
      description = "Podman Docker-compatible API Socket";
      serviceConfig = {
        ExecStart = "${pkgs.podman}/bin/podman system service --time=0 unix:///var/run/docker.sock";
        Type = "simple";
      };
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
    };
    
    # Настройка файрвола
    networking.firewall = {
      trustedInterfaces = ["podman0" "podman1"];
    };
  };
} 