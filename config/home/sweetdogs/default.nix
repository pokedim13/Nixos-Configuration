{ flake, pkgs, ... }: {  
    home = {
        username = "sweetdogs";
        homeDirectory = "/home/sweetdogs";
        stateVersion = flake.conf.stateVersion;
        packages = with pkgs; [
            fastfetch
            pavucontrol
        ];
    };
}