{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "python-poetry";
  
  buildInputs = with pkgs; [
    # Основные инструменты Python
    python313
    poetry
  ];
  
  shellHook = ''
    # Настройка Poetry для хранения виртуальных окружений в проекте
    export POETRY_VIRTUALENVS_IN_PROJECT=true
    
    # Обновление PS1 для отображения названия shell
    export PS1="\[\033[01;34m\](poetry)\[\033[00m\] $PS1"
    
    echo "Python Poetry окружение активировано!"
  '';
} 