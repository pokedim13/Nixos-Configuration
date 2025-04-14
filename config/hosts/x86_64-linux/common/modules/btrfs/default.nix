{ lib, ... }: {
  disko.devices = lib.mkDefault {
    disk = {
      nixos = {
        device = lib.mkDefault "/dev/sdc";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # Backward compatible with bios booting. 
            # It also makes it easier to install grub
            boot = {
              name = "NIXBOOT";
              size = "1M";
              type = "EF02";
            };

            ESP = {
              name = "NIXESP";
              type = "EF00";
              size = "128M";
              content = {
               type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };

            swap = lib.mkDefault {
              name = "NIXSWAP";
              size = "8G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };

            root = {
              name = "NIXROOT";
              size = "100%";
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/";
                options = lib.mkDefault [ "compress=zstd:7" "noatime" ];
              };
            };
            # Nixos disk partition END
          };
        };
      };
    };
    # New disks
  };
}