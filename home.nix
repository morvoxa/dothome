{ pkgs, ... }:

{
  home.username = "mor";
  home.homeDirectory = "/home/mor";
  home.stateVersion = "26.11"; # Match your current release version
  programs.bash = {
    enable = true;
    initExtra = ''
      export PATH=~/.local/bin:$PATH
      # Automatically launch Fish on interactive shells
      if [[ $- == *i* ]] && [[ -z "$FISH_VERSION" ]]; then
          FISH_PATH="$HOME/.nix-profile/bin/fish"
          if [ -x "$FISH_PATH" ]; then
              exec "$FISH_PATH"
          elif command -v fish &>/dev/null; then
              exec fish
          fi
      fi
    '';
  };
  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "ls -lh";
      gs = "git status";
    };
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim
    just
    git
    curl
    zellij
    #neovim tools
    tree-sitter
    clang
    nixfmt
    nixd
    shfmt
    kdlfmt
    stylua
    prettier
    taplo

  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };
}
