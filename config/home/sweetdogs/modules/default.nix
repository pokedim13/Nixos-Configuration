{ lib, ... }:

with lib;

let
  # Функция для рекурсивного сканирования директорий и импорта модулей
  scanModules = dir:
    let
      # Получаем содержимое директории
      contents = builtins.readDir dir;
      
      # Фильтруем директории, чтобы пропустить special-директории и файлы
      dirs = filterAttrs (name: type: type == "directory" && name != ".git") contents;
      
      # Проверяем, есть ли в директории default.nix
      hasDefault = name: builtins.pathExists (dir + "/${name}/default.nix");
      
      # Импортируем модули
      imports = mapAttrsToList (name: _: dir + "/${name}") (filterAttrs (name: _: hasDefault name) dirs);
      
      # Рекурсивно обрабатываем поддиректории
      submodules = concatLists (mapAttrsToList (name: _: scanModules (dir + "/${name}")) dirs);
    in
      imports ++ submodules;

  modulesPath = ./.;
  
  allModules = scanModules modulesPath;
in
{
  imports = allModules;
} 