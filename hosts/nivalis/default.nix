{ config, pkgs, inputs, ... }:

let
  getPkg = name: inputs.${name}.packages.${pkgs.system}.default;

  # Custom inputs
  swayfxPkg = getPkg "swayfx";
  weztermPkg = getPkg "wezterm";
  zenbrowserPkg = getPkg "zen-browser";
in {
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # $ fwupdmgr update (firmware)
  #services.fwupd.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nivalis";
  networking.networkmanager.enable = true;

  # Internationalization
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # User
  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    hashedPassword = "$6$oP3MZdVPRho1KWaD$1f8KQL5bUxyJOUJVqhlvtgVse250Q3uanCmx5AJw8/hcKorc99Q6rbgyYziclSWZwCEWpAmOUd8Ejk4FxN0mn1";
    # There's only one user, so it's easier if everything is installed to systemPackages
    #packages = with pkgs; [];
  };

  # Environment
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    bibata-cursors
    btop
    chezmoi
    du-dust
    git
    neovim
    pokeget-rs
    starship
    #wezterm
    wget
    xorg.xlsclients
    # Custom
    swayfxPkg
    weztermPkg # temp
    zenbrowserPkg
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    open-sans
  ];
  environment.variables = {
    EDITOR = "nvim";
  };

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
