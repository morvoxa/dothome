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
    pkgs.starship
    pkgs.fish
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
  programs.tmux = {
    enable = true;
    shortcut = "a"; # Changes prefix from Ctrl+b to Ctrl+a
    baseIndex = 1; # Start windows and panes at 1
    mouse = true; # Enable mouse support
    keyMode = "vi"; # Vi-style copy mode
    escapeTime = 0; # Instant response for modal editors like Helix/Vim
    extraConfig = ''
      # True color support
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",xterm-256color:Tc"

      # Quick configuration reload
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # Split panes using | and - (and stay in current directory)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      bind -n M-h previous-window
      bind -n M-l next-window
    '';
  };

}
