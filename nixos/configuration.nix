{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../_common/global
  ];

  # TODO: theme "greeter" user GTK instead of using ben to login
  services.greetd.settings.default_session.user = "ben";

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