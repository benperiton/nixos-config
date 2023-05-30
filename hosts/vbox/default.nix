{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../_common/global
    ../_common/users/ben
  ];

  networking = {
    hostName = "vbox";
    useDHCP = true;
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  
  system.stateVersion = "22.05";
}