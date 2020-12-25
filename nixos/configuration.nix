# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  
  home-manager = builtins.fetchTarball {
    url = "https://github.com/rycee/home-manager/archive/release-20.09.tar.gz";
  };

in {
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      "${home-manager}/nixos" 
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = { root = { device = "/dev/nvme0n1p2"; preLVM = true; }; };

  networking.hostName = "amphiptera"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.interfaces.wwp0s20f0u7.useDHCP = true;
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  
  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "colemak";
  services.xserver.xkbOptions = "caps:swapescape";
  services.xserver = {
    enable = true;
#    desktopManager.gnome3.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
    displayManager = {
      defaultSession = "none+xmonad";
    #  gdm.enable = true;
    };
  };
    

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.infty = {
    createHome = true;
    group = "users";
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "input" "docker" ]; # Enable ‘sudo’ for the user.
    uid = 1001;
  };

  home-manager.users.infty = import /home/infty/config/nixos/home.nix;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    wget vim git alacritty tarsnap
  ];




  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.light.enable = true;
  programs.nm-applet.enable = true;
  programs.vim.defaultEditor = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  users.extraGroups.vbox.members = [ "infty" ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  networking.iproute2.enable = true;
  services.mullvad-vpn.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  services.tarsnap = {
    enable = true;
      archives = {
        notes = {
        	  directories = [ "/home/infty/notes" ];
            keyfile = "/home/infty/secrets/tarsnap.key";
            verbose=true;
            period = "hourly";
        };
        documents = {
        	  directories = [ "/home/infty/documents" ];
            keyfile = "/home/infty/secrets/tarsnap.key";
            verbose=true;
            period = "weekly";
        };
    };
  };

  systemd.user.services.set-background = {
    path = [pkgs.feh];
    description = "Set background";
    script = '' feh --bg-scale /home/infty/config/xmonad/black-pixel.png '';
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  fonts.fonts = with pkgs; [
    terminus_font
    source-code-pro
  ];

  systemd.user.timers.battery-warn = {
    description = "run my-task every 5 minutes";
    wantedBy = [ "timers.target" ]; # enable it & auto start it
    timerConfig = {
      OnBootSec = "1m"; # first run 1min after boot up
      OnUnitInactiveSec = "1m"; # run 1min after my-task has finished
    };
  };
  systemd.user.services.battery-warn = {
    path = [pkgs.bc pkgs.xosd];
    description = "My Task";
    script = "/home/infty/config/bin/battery-warn";
  };

  nixpkgs.config.allowUnfree = true;

}

