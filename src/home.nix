{ pkgs, ... }:

{
  home.username = "mor";
  home.homeDirectory = "/home/mor";

  home.stateVersion = "26.05";

  home.packages = [
    pkgs.nixfmt
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
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
      pkgs.buildFHSEnv (
        base
        // {
          name = "fhs-shell";
          targetPkgs =
            pkgs:
            (base.targetPkgs pkgs)
            ++ [
              pkgs.pkg-config
              pkgs.fish
              pkgs.uv
              pkgs.nodejs

            ];
          profile = ''
            export FHS=1
          '';
          runScript = ''
            fish --init-command '
               functions -c fish_prompt _old_fish_prompt
               function fish_prompt
                   set_color --bold yellow
                   echo -n "(fhs) "
                   set_color normal
                   _old_fish_prompt
               end
             '
          '';
          extraOutputsToInstall = [ "dev" ];
        }
      )
    )
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
