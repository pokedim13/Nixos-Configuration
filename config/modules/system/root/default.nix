{ config, flake, lib, ... }:

with lib;

let
  cfg = config.modules.system.root;
in {
  options.modules.system.root = {
    enable = mkEnableOption "Базовая настройка root пользователя";
  };

  config = mkIf cfg.enable {
    users.mutableUsers = false;
    users.users.root.hashedPassword = flake.conf.rootHashedPassword;
  };
}