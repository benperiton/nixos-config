{ pkgs, config, lib, ... }:
let
  pinentry =
    if config.gtk.enable then {
      packages = [ pkgs.pinentry-gnome pkgs.gcr ];
      name = "gnome3";
    } else {
      packages = [ pkgs.pinentry-curses ];
      name = "curses";
    };
in
{
  home.packages = pinentry.packages;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = [ "B2020F074D9C4B4D7AB39E50B5E24DAA59EE9968" ];
    pinentryFlavor = pinentry.name;
    enableExtraSocket = true;
  };

  programs =
    let
      fixGpg = ''
        gpgconf --launch gpg-agent
      '';
    in
    {
      # Start gpg-agent if it's not running or tunneled in
      # SSH does not start it automatically, so this is needed to avoid having to use a gpg command at startup
      # https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
      zsh.loginExtra = fixGpg;

      gpg = {
        enable = true;
        settings = {
          trust-model = "tofu+pgp";
        };
        publicKeys = [{
          source = ../../_common/gpg.pub;
          trust = 5;
        }];
      };
    };

  systemd.user.services = {
    # Link /run/user/$UID/gnupg to ~/.gnupg-sockets
    # So that SSH config does not have to know the UID
    link-gnupg-sockets = {
      Unit = {
        Description = "link gnupg sockets from /run to /home";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/ln -Tfs /run/user/%U/gnupg %h/.gnupg-sockets";
        ExecStop = "${pkgs.coreutils}/bin/rm $HOME/.gnupg-sockets";
        RemainAfterExit = true;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}