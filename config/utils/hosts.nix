{ inputs, flake, ... }: 
let
  # Базовая функция для создания хоста
  mkHost = {system ? null, hostname, modules? []}: 
    let
      # Используем переданную систему
      finalSystem = system;
    in inputs.nixpkgs.lib.nixosSystem {
      system = finalSystem;
      specialArgs = {
        inherit inputs flake;
      };
      modules = [
        { networking.hostName = hostname; }
        "${flake.conf.overlays}/nixpkgs"
        "${flake.conf.utils}/users.nix"
        inputs.disko.nixosModules.disko
        inputs.sops.nixosModules.sops
      ] ++ modules;
    };

  # Получаем список архитектур
  architectures = builtins.attrNames (builtins.readDir flake.conf.hosts);
  
  # Функция для обработки одной архитектуры
  processArch = arch: 
    let
      archPath = "${flake.conf.hosts}/${arch}";
      hostTypes = builtins.attrNames (builtins.readDir archPath);
      
      # Функция для обработки типа хоста
      processHostType = hostType: 
        let
          configPath = "${archPath}/${hostType}/default.nix";
        in
          # Проверяем существование default.nix
          if builtins.pathExists configPath then
            [{
              name = hostType;
              value = mkHost (
                # Импортируем конфигурацию и автоматически добавляем system из пути
                let
                  config = import configPath {inherit inputs flake;};
                in config // { system = arch; }
              );
            }]
          else
            [];
    in
      builtins.concatLists (map processHostType hostTypes);
  
  # Собираем все хосты по архитектурам
  allHosts = builtins.concatLists (map processArch architectures);
  
in builtins.trace "Initialization hosts" builtins.listToAttrs allHosts