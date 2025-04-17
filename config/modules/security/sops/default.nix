{ config, lib, flake, ... }:

with lib;

let
  cfg = config.modules.security.sops;
in {
  options.modules.security.sops = {
    enable = mkEnableOption "Поддержка sops для секретов";
    
    defaultSopsFile = mkOption {
      type = types.path;
      default = "${flake.conf.secrets}/secrets.yaml";
      description = "Путь к файлу с секретами по умолчанию";
    };
    
    age = {
      keyFile = mkOption {
        type = types.path;
        default = "/run/keys/sops_age_key";
        description = "Путь к AGE ключу в системе";
      };
      
      keySource = mkOption {
        type = types.path;
        default = "${flake.conf.secrets}/keys.txt";
        description = "Исходный путь к AGE ключу в конфигурации";
      };
    };
  };

  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = cfg.defaultSopsFile;
      age = {
        keyFile = cfg.age.keyFile;
      };
      
      # Автоматический импорт всех секретов из файла
      secrets = lib.mapAttrs (_: _: {}) 
        (lib.filterAttrs (n: _: n != "sops") 
         (builtins.fromJSON 
           (builtins.readFile 
             (builtins.toFile "secrets-json" (builtins.readFile cfg.defaultSopsFile)))));
    };
    
    # Настраиваем systemd-сервис для копирования ключа в безопасное место
    systemd.services.copy-sops-key = {
      description = "Копирование AGE ключа для sops";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        mkdir -p /run/keys
        cp ${cfg.age.keySource} /run/keys/sops_age_key
        chmod 600 /run/keys/sops_age_key
      '';
    };
  };
}
