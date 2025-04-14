{
  # Структура путей конфига
  home = ./home;
  hosts = ./hosts;
  hm-modules = ./hm-modules;
  modules = ./modules;
  overlays = ./overlays;
  users = ./users; 
  utils = ./utils; 

  # Конфигурация системы
  timeZone = "Europe/Moscow";
  stateVersion = "25.05";

  # Конфигурация для установки
  # Список пользователей которых следует установить
  lusers = ["sweetdogs"];
  # Пароль супер пользователя (делается через mkpasswd)
  rootHashedPassword = "$6$pokedim13$2HDvjLbVa6wItmJRywWvxO2dB2Wxopjvt3DY9CU3qMJc/8Ho6eoV8PWcUG/0M03avtMb1DYKQT63ZpYqPCUWL1";
}