{
    # Структура путей конфига
    home = ./home;
    hosts = ./hosts;
    modules = ./modules;
    overlays = ./overlays;
    secrets = ./secrets;
    shells = ./shells;
    users = ./users; 
    utils = ./utils; 

    # Конфигурация системы
    timeZone = "Europe/Moscow";
    stateVersion = "25.05";

    # Конфигурация для установки
    # Список пользователей которых следует установить
    lusers = ["sweetdogs"];
}