{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.system.shell.zsh;
in {
  options.modules.system.shell.zsh = {
    enable = mkEnableOption "Настройка оболочки zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    
    users.defaultUserShell = pkgs.zsh;
  };
} 