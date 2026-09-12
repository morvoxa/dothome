{ pkgs, ... }: {

  services.xserver.enable = true;
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.windowManager.dwm = {
    package = pkgs.dwm.overrideAttrs (oldAttrs: {
      patches = [ ./dwm/dwm-cool_autostart-6.5.diff ];
      postPatch = (oldAttrs.postPatch or "") + ''
        cp ${./dwm/config.h} config.h
      '';
    });
  };

  services.displayManager.ly.enable = true;
  environment.systemPackages = with pkgs; [
    st
    alacritty
    dmenu
  ];
}
