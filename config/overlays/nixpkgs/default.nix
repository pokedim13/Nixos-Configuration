{inputs, ...}: {
  # nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: _prev: {
      stable = import inputs.stable {
        inherit (final) system; 
        config = {allowBroken = true;};
      };
      stable-unfree = import inputs.stable {
        inherit (final) system; 
        config = {allowBroken = true;allowUnfree = true;};
      };
      unstable = import inputs.unstable {
        inherit (final) system; 
        config = {allowBroken = true;};
      };
      unstable-unfree = import inputs.unstable {
        inherit (final) system; 
        config = {allowBroken = true;allowUnfree = true;};
      };
      master = import inputs.master {
        inherit (final) system; 
        config = {allowBroken = true;};
      };
      master-unfree = import inputs.master {
        inherit (final) system; 
        config = {allowBroken = true;allowUnfree = true;};
      };
    })
  ];
} 