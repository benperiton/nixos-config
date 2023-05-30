{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../_common/global
  ];

  networking = {
    hostName = "vbox";
    useDHCP = true;
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" ];
  };
  
  system.stateVersion = "22.05";
}