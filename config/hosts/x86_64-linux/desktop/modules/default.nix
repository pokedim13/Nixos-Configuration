{ pkgs, inputs, ... }: {
  modules.dev.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket = true;
    autoPrune = true;
    installCompose = true;
    installTui = true;
  };

  modules.display.xorg = {
    enable = true;
    videoDrivers = [ "amdgpu" ];  
  };
  modules.display.dm.sddm.enable = true;
  modules.display.wm.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };


  modules.hardware.graphics.enable = true;
  modules.hardware.tablet.enable = true;
  modules.hardware.bluetooth = {
    enable = true;
    gui = true;  # Включаем графический интерфейс Blueman
  };
  modules.hardware.disks = {
    enable = true;
    gui = true;  # Включаем графический интерфейс gnome-disks
  };
  modules.hardware.pipewire = {
    enable = true;
    lowLatency = true; # Включаем настройки низкой задержки для аудио, может вызывать проблемы с прерываниями звука
  };


  modules.programs.adb.enable = true;
  # modules.programs.dconf.enable = true;
  modules.programs.earlyoom.enable = true;
  # modules.programs.kdeconnect.enable = true;
  modules.programs.steam = {
    enable = true;
    package = pkgs.master-unfree.steam;
    hardware = true;
    protonGE = true;
    protontricks = true;
    gamescope = true;
    gamemode = true;
    networking = {
      dedicatedServer = true;
      localNetworkGame = true;
      remotePlay = true;
    };
  };

  modules.system.sysctl.enable = true;
  modules.system.shell.zsh.enable = true;
  modules.system.zram.enable = true;
}