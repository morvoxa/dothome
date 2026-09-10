{ pkgs, ... }: {
  programs.hyprland.enable = true;
  services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    waybar
    hyprlauncher
  ];
  programs.dconf.enable = true;

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    }
  ];
}
