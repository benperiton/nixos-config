{ pkgs, config, ... }:
let ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false;
  users.users.ben = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ] ++ ifTheyExist [
      "network"
      "docker"
      "podman"
      "git"
      "libvirtd"
      "games"
      "vboxusers"
      "disk"
      "plugdev"
    ];

    #openssh.authorizedKeys.keys = [ (builtins.readFile ../../../../home/ben/ssh.pub) ];
    #passwordFile = config.sops.secrets.ben-password.path;
    password = "bob";
    packages = [ pkgs.home-manager ];
  };

  sops.secrets.ben-password = {
    sopsFile = ./secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.ben = import ../../../../home/ben/${config.networking.hostName}.nix;

  services.geoclue2.enable = true;
  security.pam.services = { swaylock = { }; };
}