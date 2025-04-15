{ flake, lib, ... }: {
  users.users.sweetdogs = {
    description = "Aleksey Baev";
    createHome = true;
    isNormalUser = true;
    hashedPassword = lib.mkDefault flake.conf.rootHashedPassword;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "video"
      "libvirtd"
      "adbusers"
    ];
  };
}