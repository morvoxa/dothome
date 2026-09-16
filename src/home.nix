{ pkgs, ... }:

{

  home.username = "mor";
  home.homeDirectory = "/home/mor";
  home.stateVersion = "26.05";
  home.packages = [
    pkgs.nixfmt
    pkgs.neovim
    pkgs.nixd
    pkgs.taplo
    pkgs.stylua
    pkgs.just
    pkgs.helix
    pkgs.wl-clipboard-rs
    pkgs.lsd
    pkgs.unzip
    pkgs.yazi
    pkgs.fastfetch
    pkgs.shfmt
  ];
  programs.bash = {
    enable = true;
    initExtra = ''
      # Auto-run Fish shell if it is installed
      if [ -x "$(command -v fish)" ] && [ "$BASH_EXECUTION_STRING" = "" ]; then
          exec fish
      fi
    '';
  };

  programs.fish.enable = true;

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
