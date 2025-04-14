{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "python-uv";
  
  buildInputs = with pkgs; [
    # Основные инструменты Python
    python313
    uv
  ];
  
  shellHook = ''
    # Обновление PS1 для отображения названия shell
    export PS1="\[\033[01;32m\](uv)\[\033[00m\] $PS1"
    
    echo "Python uv окружение активировано!"
  '';
} 