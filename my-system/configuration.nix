# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.userControlled.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stk = {
    isNormalUser = true;
    description = "Stanislovas";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "docker" "plugdev" "dialout" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.loader.systemd-boot.configurationLimit = 5;
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";

  # Enable audio
  services.pipewire.enable = false;
  services.pulseaudio.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # system utils
    v4l-utils
    powertop
    usbutils
    udiskie
    udisks
    powertop
    light
    docker-compose
    unzip
    fastfetch
    ncdu
    duplicity
    imagemagick
    gst_all_1.gstreamer
    gst_all_1.icamerasrc-ipu6
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    v4l2-relayd
    
    # sway/wayland utils
    grim
    slurp
    wl-clipboard
    mako
    i3status
    rofi-wayland
    swayidle
    wshowkeys

    # audio
    alsa-tools
    alsa-utils
    pavucontrol
    pa-notify
    pamixer
    pasystray
    
    # utils
    jq
    curl
    fd
    gnumake
    playerctl
    wget
    nomacs
    tesseract

    # applications
    alacritty
    alacritty-theme
    calibre
    git
    deluge
    discord
    onlyoffice-bin
    thunderbird
    vlc
    postman
    inkscape
    vivaldi
    obs-studio
    acpica-tools

    # languages
    stylua
    lua-language-server
    clang
    gcc
    nixd
    python312
    python312Packages.pip
    rustup
    uv
    zig
    zsh

    # games
    lunar-client
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.monofur
    corefonts
    vistafonts
  ];

  programs.zsh.enable = true;

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
  };

  programs.wshowkeys.enable = true;

  systemd.timers."my-backup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "30 minutes";
      OnUnitActiveSec = "30 minutes";
      Unit = "my-backup.service";
    };
  };

  systemd.services."my-backup" = {
    script = ''
      ${pkgs.duplicity}/bin/duplicity backup --no-encryption --exclude /home/stk/.cache --exclude /home/stk/.mozilla /home/stk scp://girlboss//mnt/newtent/pupa
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "stk";
    };
  };

  # services.swayidle = {
  #   enable = true;
  #   events = [
  #     {
  #       event = "before-sleep";
  #       command = "${pkgs.swaylock}/bin/swaylock -k";
  #     }
  #   ];
  # };

  services.blueman.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.avahi.enable = true;

  services.gvfs.enable = true;

  services.udisks2.enable = true;

  services.tumbler.enable = true;

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  services.keyd = {
    enable = true;
    keyboards = {
      # The name is just the name of the configuration file, it does not really matter
      default = {
        ids = [ "*" ]; # what goes into the [id] section, here we select all keyboards
        # Everything but the ID section:
        settings = {
          # The main layer, if you choose to declare it in Nix
          main = {
            capslock = "overload(control, esc)"; # you might need to also enclose the key in quotes if it contains non-alphabetical symbols
          };
          otherlayer = {};
        };
        extraConfig = ''
          # put here any extra-config, e.g. you can copy/paste here directly a configuration, just remove the ids part
        '';
      };
    };
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.swayfx}/bin/sway";
        user = "stk";
      };
      default_session = initial_session;
    };
  };

  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
    6969 8000 8080  # development stuff
  ];

  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
