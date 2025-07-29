{ config, pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  hypr = inputs.hyprland.packages.${system}.hyprland;
  portal = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
in
{
  home.stateVersion = "25.05";
  
  # Gestión de otros archivos de configuración
  home.file = {
    ".config/nix/nix.conf".source = ./dotfiles/config/nix/nix.conf;
    ".config/waybar/config.jsonc".source = ./dotfiles/config/waybar/config.jsonc;
    ".config/waybar/style.css".source = ./dotfiles/config/waybar/style.css;
  };

  # Configuración completa de Hyprland integrada en Nix
  wayland.windowManager.hyprland = {
    enable = true;
    package = hypr;
    portalPackage = portal;
    systemd.enable = true;  # Para mejor integración
    xwayland.enable = true; # Soporte para aplicaciones X11
    
    # ¡Toda tu configuración de Hyprland aquí!
    settings = {
      monitor = ",preferred,auto,auto";
      
      # Programas
      "$terminal" = "kitty";
      "$fileManager" = "yazi";
      "$menu" = "wofi --show drun";
      
      # Autostart
      exec-once = [
        "dbus-update-activation-environment --systemd --all"
        "waybar"
        "swaync"
      ];
      
      # Variables de entorno
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];
      
      # Apariencia
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(ffffffee)";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };
      
      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 0.9;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      
      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "linear, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 4, wind, slide"
          "windowsIn, 1, 4, winIn, slide"
          "windowsOut, 1, 3, winOut, slide"
          "windowsMove, 1, 3, wind, slide"
          "border, 1, 1, linear"
          "borderangle, 1, 30, linear, once"
          "fade, 1, 8, default"
          "workspaces, 1, 3, wind"
          "specialWorkspace, 1, 3, wind, slidevert"
        ];
      };
      
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      master.new_status = "master";
      
      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };
      
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = false;
      };
      
      gestures.workspace_swipe = false;
      
      # Dispositivos específicos (ejemplo)
      # device = {
      #   name = "epic-mouse-v1";
      #   sensitivity = -0.5;
      # };
      
      # Atajos de teclado
      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, kitty -e $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, SPACE, exec, $menu"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, J, togglesplit," # dwindle

	", PRINT, exec, bash -lc 'grim -g \"$(slurp)\" ~/Pictures/screenshot_$(date +\"%Y%m%d_%H%M%S\").png && swappy -f ~/Pictures/screenshot_$(date +\"%Y%m%d_%H%M%S\").png'"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      
      # Reglas de ventana
      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };

  programs.nushell.enable = true;
}
