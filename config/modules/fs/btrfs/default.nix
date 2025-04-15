{ config, lib, ... }:

with lib;

let
  cfg = config.modules.fs.btrfs;
in {
  options.modules.fs.btrfs = {
    enable = mkEnableOption "Включение и настройка файловой системы btrfs";
    
    device = mkOption {
      type = types.str;
      default = "/dev/sda";
      description = "Путь к устройству для btrfs";
    };
    
    mountOptions = mkOption {
      type = types.listOf types.str;
      default = [ "defaults" ];
      example = [ "compress=zstd:3" "noatime" "space_cache=v2" ];
      description = "Опции монтирования для корневого раздела btrfs";
    };
  };

  config = mkIf cfg.enable {
    # Переопределяем конфигурацию disko
    disko.devices.disk.nixos = {
      device = cfg.device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "NIXBOOT";
            size = "1M";
            type = "EF02";
          };

          ESP = {
            name = "NIXESP";
            type = "EF00";
            size = "128M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          swap = {
            name = "NIXSWAP";
            size = "8G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };

          root = {
            name = "NIXROOT";
            size = "100%";
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/";
              mountOptions = cfg.mountOptions;
            };
          };
        };
      };
    };
  };
} 