{
  config,
  lib,
  ...
}:
{
  options.hypr-config = {
    enable = lib.mkEnableOption "enable hypr config";
    hyprland.enable = lib.mkEnableOption "enable hyprland config";
    hypridle.enable = lib.mkEnableOption "enable hypridle config";
    hyprlock.enable = lib.mkEnableOption "enable hyprlock config";
    hyprpaper.enable = lib.mkEnableOption "enable hyprpaper config";
  };

  config = lib.mkIf config.hypr-config.enable {

    # hyprland
    wayland.windowManager.hyprland = lib.mkIf config.hypr-config.hyprland.enable {
      enable = true;
      systemd.enable = true;
    };

    home.file.".config/hypr" = lib.mkIf config.hypr-config.hyprland.enable {
      source = ../../resources/hypr;
      recursive = true;
    };

    # hypridle
    services.hypridle = lib.mkIf config.hypr-config.hypridle.enable {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 600; # 10min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }
          {
            timeout = 330; # 5.5min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
          }
          {
            timeout = 21600; # 6h
            on-timeout = "systemctl suspend"; # suspend pc
          }
        ];
      };
    };

    # hyprlock
    programs.hyprlock = lib.mkIf config.hypr-config.hyprlock.enable {
      enable = true;
      settings = {
        general = {
          ignore_empty_input = true;
        };

        background = [
          {
            blur_passes = 1;
            blur_size = 7;
            noise = 1.17e-2;
            contrast = 0.8916;
            brightness = 0.8172;
            vibrancy = 0.1696;
            vibrancy_darkness = 0.0;
            color = "rgba(39, 44, 68, 0.99)";
          }
        ];

        image = [
          {
            path = "~/.dotfiles/001-Ocean Breeze/.config/hypr/hyprlock.png";
            size = "150";
            rounding = -1;
            border_size = 0;
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = [
          {
            size = "300, 40";
            position = "0, -20";
            monitor = "";
            outline_thickness = 1;
            dots_size = 0.33;
            dots_spacing = 0.15;
            dots_center = true;
            dots_rounding = -1;
            outer_color = "rgb(254, 179, 1)";
            inner_color = "rgb(39, 44, 68)";
            font_color = "rgb(223, 90, 78)";
            fade_on_empty = false;
            fade_timeout = 1000;
            placeholder_text = ''<span foreground="##fef2d0">Input Password...</span>'';
            hide_input = false;
            rounding = -1;
            check_color = "rgb(204, 136, 34)";
            fail_color = "rgb(204, 34, 34)";
            fail_text = "$FAIL <b>($ATTEMPTS)</b>";
            fail_transition = 300;
            capslock_color = "rgb(209, 53, 222)";
            numlock_color = "rgb(19, 221, 126)";
            bothlock_color = -1;
          }
        ];

        label = [
          {
            text = "Hello There, $USER";
            color = "rgba(254, 242, 208, 1.0)";
            font_size = 25;
            font_family = "FiraCode Nerd Font Mono";
            rotate = 0;
            position = "0, 80";
            halign = "center";
            valign = "center";
          }
          {
            text = "$TIME";
            color = "rgba(254, 242, 208, 1.0)";
            font_size = 20;
            font_family = "FiraCode Nerd Font Mono";
            position = "0, 50";
            halign = "center";
            valign = "bottom";
          }
        ];
      };
    };

    # hyprpaper 
    services.hyprpaper = lib.mkIf config.hypr-config.hyprpaper.enable {
      enable = true;
      settings = {
        ipc = "on";

        preload = [ "${../../resources/hypr/hyprpaper.jpg}" ];

        wallpaper = [
          "HDMI-A-2,${../../resources/hypr/hyprpaper.jpg}"
        ];
      };
    };
  };
}
