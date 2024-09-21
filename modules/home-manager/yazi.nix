{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.yazi-config = {
    enable = lib.mkEnableOption "enable yazi config";
    enableBashIntegration = lib.mkEnableOption "enable yazi bash integration, passed to programs.yazi.enableBashIntegration";
    enableFishIntegration = lib.mkEnableOption "enable yazi fish integration, passed to programs.yazi.enableFishIntegration";
    enableNushellIntegration = lib.mkEnableOption "enable yazi nushell integration, passed to programs.yazi.enableNushellIntegration";
    enableZshIntegration = lib.mkEnableOption "enable yazi zsh integration, passed to programs.yazi.enableZshIntegration";

  };

  config = lib.mkIf config.yazi-config.enable {
    home.packages = with pkgs; [
      zoxide
      ripgrep
      fzf
      jq
      poppler
      imagemagick
      swayimg
      p7zip
    ];

    programs.yazi = {
      enable = true;
      enableBashIntegration = config.yazi-config.enableBashIntegration;
      enableFishIntegration = config.yazi-config.enableFishIntegration;
      enableNushellIntegration = config.yazi-config.enableNushellIntegration;
      enableZshIntegration = config.yazi-config.enableZshIntegration;

      initLua = ../../resources/yazi/init.lua;
      plugins = {
        smart-enter = ../../resources/yazi/plugins/smart-enter.yazi;
      };

      keymap = {
        manager = {
          prepend_keymap = [
            {
              on = "b";
              run = "cd ~";
            }
            {
              on = "<C-q>";
              run = "quit --no-cwd-file";
            }
            {
              on = "i";
              run = "shell --confirm --orphan \"swayimg \\\"$@\\\"\"";
            }
            {
              on = "l";
              run = "plugin --sync smart-enter";
              desc = "Enter the child directory, or open the file";
            }
            {
              on = "R";
              run = "shell --confirm --block \"gtrash restore\"";
            }
            {
              on = "n";
              run = "shell --confirm --block \"$EDITOR\"";
            }
          ];
        };
      };

      settings = {
        manager = {
          ratio = [
            1
            4
            3
          ];
          sort_by = "natural";
          sort_sensitive = false;
          sort_dirs_first = true;
          sort_translit = true;
          show_hidden = true;
        };
      };

      theme = {
        manager = {
          hovered = {
            fg = "magenta";
          };
        };

        filetype = {
          rules = [
            {
              mime = "image/*";
              fg = "yellow";
            }
            {
              mime = "{audio,video}/*";
              fg = "white";
            }
            {
              mime = "application/{,g}zip";
              fg = "red";
            }
            {
              mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}";
              fg = "red";
            }
            {
              mime = "application/{pdf,doc,rtf,vnd.*}";
              fg = "cyan";
            }
            {
              name = "*";
              is = "orphan";
              fg = "red";
            }
            {
              name = "*";
              is = "exec";
              fg = "green";
            }
            {
              name = "*/";
              fg = "blue";
            }
          ];
        };
      };

    };
  };
}
