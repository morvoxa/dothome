{ pkgs, ... }:

{
  home.username = "mor";
  home.homeDirectory = "/home/mor";

  home.stateVersion = "26.05";

  home.packages = [
    pkgs.nixd
    pkgs.nixfmt
    pkgs.taplo
    pkgs.just
    pkgs.helix
    pkgs.wl-clipboard-rs
    pkgs.lsd
    pkgs.unzip
  ];

  programs.git = {
    enable = true;
  };
  programs.home-manager.enable = true;
  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
  '';
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

}
