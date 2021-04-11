{ config, pkgs, ... }:

let
  configdir = "/home/infty/config";
  home = "/home/infty";
  # unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz;
  unstable = import unstableTarball { config = { allowUnfree = true; }; };
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {inherit pkgs;};
  tarsnap_key_file = "/home/infty/secrets/tarsnap.key";
  file-opener = pkgs.writeScriptBin "o" ''
      xdg-open $1 & disown
  '';   
in {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita-dark";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
    gtk3.bookmarks = [
      "${home}/downloads"
    ];
  };
  home.packages = with pkgs; [ # list of packages
    file-opener
    ripgrep-all
    pandoc
    krop # gui pdf cropper
    masterpdfeditor
    xournal
    mypaint
    xorg.xev
    pcre
    xorg.xmessage
    maim # screenshot utility
    killall
    xbindkeys # for configuring mouse buttons together with xvkbd
    xvkbd # for configuring mouse buttons together with xbindkeys
    simplescreenrecorder
    discord
    ispell
    pdftk
    pulseeffects
    spotifyd
    spotify-tui
    fd
    tealdeer
    jetbrains.pycharm-community
    # factorio
    xcalib
    gopass
    rxvt-unicode
    ueberzug
    libcaca
    w3m
    mupdf
    nur.repos.moredread.nix-search # see https://discourse.nixos.org/t/handy-scripts-for-fuzzy-searching-nixpkgs-and-nixos-options/1659 (search: `generate`)NOTE throws errors
    acpi
    ag
    age
    age
    bat
    black
    dconf # needed for gtk theme
    deluge
    dzen2
    element-desktop
    feh
    fzf
    gcc
    ghc
    google-cloud-sdk
    libstdcxx5 # dependency for pandas
    magic-wormhole
    mpv
    mullvad-vpn
    ncdu
    neovim
    niv
    peco
    picom # replacement for compton
    #python38Packages.pudb
    python39Full
    python39Packages.pyyaml # required by alacritty-theme-switch.py
    python39Packages.virtualenv
    rage
    ranger
    redshift
    ripgrep
    rstudio
    scrot
    signal-desktop
    skim
    slack
    tdesktop
    unstable.tectonic
    theme-vertex
    tor-browser-bundle-bin
    tree
    unstable.haskellPackages.haskell-language-server
    unstable.ledger-live-desktop
    unstable.monero-gui
    unstable.nodePackages.pyright
    unstable.qutebrowser
    unstable.yggdrasil
    unstable.zoom-us
    unzip
    vimPlugins.vim-plug
    xclip
  ];

  services = {
    flameshot.enable = true;
    # picom = {
    #   enable = true;
    #   inactiveDim = "0.1";
    # };
    spotifyd.enable = true;
    emacs.enable = true;
    unclutter.enable = true; # hide cursor after set time
    gpg-agent.enable = true;
  };

  programs = {
    gpg = {
      enable = true;
    };
    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };
    zathura = {
       enable = true;
       options = {
         default-bg = "#101215";
         selection-clipboard = "clipboard";
         recolor = "true";
	 window-title-home-tilde = "true";
	 statusbar-home-tilde = "true";
       };
     };
    alacritty = {
      enable = true;
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        add_newline = true;
        # prompt_order = [ "directory" "git_branch" "nix_shell" "python" "character" ];
        prompt_order = [ "directory" "git_branch" "nix_shell" "character" ];
        # prompt_order = [ "directory" "nix_shell" "character" ];
        scan_timeout = 10;
        character.symbol = "$";
      };
    };
    emacs = {
      enable = true;
    };
    git = {
      enable = true;
      userEmail = "git@vaki.li";
      userName  = "Adrien Vakili";
    };
    firefox = {
      enable = true;
      extensions =
        with nur.repos.rycee.firefox-addons; [
          ublock-origin
          decentraleyes
          # extensions to add manually: new tab override (to use about:blank as new tab page)
        ];
      profiles = {
        myprofile = {
          isDefault = true;
          id = 0;
          settings = { # firefox settings (corresponding to about:config)
            "browser.aboutConfig.showWarning"                     = false;
            "browser.ctrlTab.recentlyUsedOrder"                   = false; # prevent silly ctrl-tab behavior
            "browser.defaultbrowsernotificationbar"               = false;
            "browser.display.background_color"                    = "#FFFFFF"; # firefox light
            "browser.download.dir"                                = "/home/infty/downloads";
            "browser.download.folderList"                         = 2;
            "browser.newtabpage.enabled"                          = false; # disable annoying new tab page
            "browser.search.countryCode"                          = "US";
            "browser.search.isUS"                                 = true;
            "browser.search.region"                               = "US";
            "browser.shell.checkDefaultBrowser"                   = false;
            "browser.startup.homepage"                            = "about:blank";
            "browser.tabs.warnOnClose"                            = false;
            "extensions.activeThemeID"                            = "firefox-compact-dark@mozilla.org";
            "network.http.sendRefererHeader"                      = 0; # privacy
            "privacy.resistFingerprinting"                        = true;
            "privacy.userContext.enabled"                         = true; # related to containers
            "privacy.userContext.longPressBehavior"               = 2; # related to containers
            "privacy.userContext.ui.enabled"                      = true; # related to containers
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # tells firefox to look for userChrome.css
            "ui.systemUsesDarkTheme"                              = 1;
            # "browser.display.background_color"                  = "#1D1B19"; # firefox dark
          };
        };
      };
    };
    bash = {
      enable = true;
      historyControl = [ "erasedups" ];
      historyFileSize = 100000;
      historySize = 10000000;
      historyIgnore = [ "l" "ls" "exit" "cd"];
      shellAliases = { # bash aliases
        "d"     = "date --iso-8601";
        ".."     = "cd ..";
        "..."    = "cd ../..";
        "vim"    = "nvim";
        "ns"     = "nix-shell";
        "sw"     = "sudo nixos-rebuild switch";
	"tarsnap" = "tarsnap --keyfile ${tarsnap_key_file}";
      };
      initExtra = ''
  echo -e "\e]2;$(pwd)\e\\" # set title to working directory
	export HISTCONTROL=ignoreboth:erasedups # deduplicate history
  export DIRENV_LOG_FORMAT= # make direnv silent
      '';
    };
    chromium = {
      enable = true;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      ];
    };
    irssi = {
      enable = true;
      networks = {
        freenode = {
          nick = "infty";
          server = {
            address = "chat.freenode.net";
            port = 6697;
            autoConnect = false;
          };
          channels = {
            nixos.autoJoin = false;
          };
        };
      };
    };
    mpv = {
      enable = true;
    };
    rofi = {
      enable = true;
      # theme = "gruvbox-dark";
        extraConfig = ''
          ! the following line unbinds C-l to make it available for rebinding
          rofi.kb-remove-to-eol:
          rofi.kb-accept-entry: Control+l,Return,KP_Enter
          rofi.kb-row-up: Up,Control+k,ISO_Left_Tab
          rofi.kb-row-down: Down,Control+j
        '';
    };
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

  };

  home.file = {
    ".local/share/applications/emacsclient.desktop".source    = "${configdir}/misc/emacsclient.desktop";
    ".config/nixpkgs/config.nix".source                       = "${configdir}/nixos/config.nix";
    ".config/alacritty/alacritty.yml".source                              = "${configdir}/alacritty/alacritty.yml";
    ".emacs.d/layers/direnv".source                           = "${configdir}/emacs/layers/direnv";
    ".xmonad/autostart.sh".source                             = "${configdir}/xmonad/autostart.sh";
    ".config/qutebrowser/config.py".source                    = "${configdir}/qutebrowser/config.py";
    ".local/share/qutebrowser/userscripts".source             = "${configdir}/qutebrowser/userscripts/";
    ".local/share/qutebrowser/greasemonkey".source            = "${configdir}/qutebrowser/greasemonkey/"; # remember to run :greasemonkey-reload
    ".config/ranger/rifle.conf".source                        = "${configdir}/ranger/rifle.conf";
    ".config/ranger/rc.conf".source                           = "${configdir}/ranger/rc.conf";
    ".config/ranger/scope.sh".source                           = "${configdir}/ranger/scope.sh";
    ".mozilla/firefox/myprofile/chrome/userChrome.css".source = "${configdir}/firefox/userChrome.css";
    ".config/qutebrowser/quickmarks".text = ''mc https://mullvad.net/en/check/'';
    ".config/user-dirs.dirs".source = "${configdir}/misc/user-dirs.dirs"; # prevents creation of directories ~/Downloads and ~/Desktop
    xmonad-config = {
      source = "${configdir}/xmonad/xmonad.hs";
      target = ".xmonad/xmonad.hs";
    };
  };

   # xdg.userDirs = {
   #   desktop   = "\$HOME";
   #   documents ="\$HOME/documents";
   #   download  = "\$HOME/downloads";
   #   pictures  = "\$HOME/images";
   # };

  systemd.user.tmpfiles.rules = [
    "d /home/infty/archive   - - - - -"
    "d /home/infty/documents - - - - -"
    "d /home/infty/downloads - - - - -"
    "d /home/infty/images    - - - - -"
    "d /home/infty/media     - - - - -"
    "d /home/infty/notes     - - - - -"
    "d /home/infty/projects  - - - - -"
    "d /home/infty/secrets   - - - - -"
    "d /home/infty/tmp       - - - - -"
  ];

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/pdf"               = [ "org.pwmt.zathura.desktop" ];
    "text/html"                     = [ "qutebrowser.desktop" ];
    "text/plain"                    = [ "emacsclient.desktop" ];
    "text/x-tex"                    = [ "emacsclient.desktop" ];
    "x-scheme-handler/http"         = [ "qutebrowser.desktop" ];
    "x-scheme-handler/https"        = [ "qutebrowser.desktop" ];
    "application/x-extension-htm"   = [ "qutebrowser.desktop" ];
    "application/x-extension-html"  = [ "qutebrowser.desktop" ];
    "application/x-extension-shtml" = [ "qutebrowser.desktop" ];
    "application/xhtml+xml"         = [ "qutebrowser.desktop" ];
    "application/x-extension-xht"   = [ "qutebrowser.desktop" ];
    "image/png"                     = [ "feh.desktop" ];
    "image/vnd.djvu"                = [ "org.pwmt.zathura.desktop" ];
    # "x-scheme-handler/about"        = [ "qutebrowser.desktop" ];
    # "x-scheme-handler/unknown"      = [ "qutebrowser.desktop" ];
  };

  nixpkgs.config.allowUnfree = true;

}
