{ config, pkgs, inputs, ... }:

let
  getPkg = name: inputs.${name}.packages.${pkgs.system}.default;

  # Custom inputs
  swayfxPkg = getPkg "swayfx";
  zenbrowserPkg = getPkg "zen-browser";
  weztermPkg = getPkg "wezterm";
in {
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # $ fwupdmgr update (firmware)
  services.fwupd.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nivalis"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    hashedPassword = "$6$oP3MZdVPRho1KWaD$1f8KQL5bUxyJOUJVqhlvtgVse250Q3uanCmx5AJw8/hcKorc99Q6rbgyYziclSWZwCEWpAmOUd8Ejk4FxN0mn1";
    # There's only one user, so it's easier if everything is installed to systemPackages
    #packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Environment
  environment.systemPackages = with pkgs; [
    neovim
    btop
    wget
    git
    #wezterm
    weztermPkg
    swayfxPkg
    zenbrowserPkg
    pokeget-rs
    starship
    bibata-cursors
    xorg.xlsclients
    du-dust
  ];
  environment.variables.EDITOR = "nvim";
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    open-sans
  ];

  # Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  programs.starship = {
    enable = true;
    presets =
      [
        "nerd-font-symbols"
      ];
  };

  # Display manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      #--sessions ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions:${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --asterisks --remember --time --cmd ${swayfxPkg}/bin/sway";
      user = "greeter";
    };
  };
  # currently broken
  #services.displayManager.ly = {
  #  enable = true;
  #  settings = {
  #    vi_mode = true;
  #    animation = "gameoflife";
  #    bigclock = "en";
  #  };
  #};

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # https://nixos.org/nixos/options.html
  system.stateVersion = "25.05";
}
