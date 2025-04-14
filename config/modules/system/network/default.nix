{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkDefault
    mkForce
    ;

  cfg = config.modules.system.network;
in {
  options = {
    modules.system.network = {
      enable = mkEnableOption "Enables network";
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      network.enable = true;

      services = {
        NetworkManager-wait-online.enable = false;
        systemd-networkd-wait-online.enable = mkForce false;
      };
    };

    networking = {
      firewall = {
        enable = true;
      };

      networkmanager = {
        enable = true;
        wifi.macAddress = "random";
        wifi.backend = "iwd";
      };

      wireless.iwd = {
        enable = true;

        settings = {
          Settings = {
            AutoConnect = true;
          };
        };
      };

      useDHCP = mkDefault true;
    };
  };
}