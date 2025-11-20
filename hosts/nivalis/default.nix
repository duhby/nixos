{
  pkgs,
  inputs,
  ...
}: let
  unstablePkgs = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
  # Custom inputs
  getPkg = name: inputs.${name}.packages.${pkgs.system}.default;
  claudecodePkg = getPkg "claude-code";
  opencodePkg = getPkg "opencode";
  swayfxPkg = getPkg "swayfx";
  terminalRainLightningPkg = getPkg "terminal-rain-lightning";
  weztermPkg = getPkg "wezterm";
  zenbrowserPkg = getPkg "zen-browser";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["root" "josh"];

  # $ fwupdmgr update (firmware)
  #services.fwupd.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nivalis";
  networking.networkmanager.enable = true;
  networking.nameservers = ["1.1.1.1" "9.9.9.9"];

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
    extraGroups = ["networkmanager" "wheel" "audio" "video" "docker"];
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
    unstablePkgs.cursor-cli
    delta
    devenv
    dict
    direnv
    du-dust
    dunst
    eza
    gcc
    gimp3
    git
    lazydocker
    unstablePkgs.lunar-client
    neovim
    nix-search-cli
    pokeget-rs
    neofetch
    rage
    ripgrep
    rofi-wayland
    starship
    sway-contrib.grimshot
    swaylock
    tt
    unzip
    #wezterm
    wget
    wl-clipboard
    xorg.xlsclients
    # Custom
    claudecodePkg
    opencodePkg
    swayfxPkg
    terminalRainLightningPkg
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
  programs.nix-ld.enable = true;
  virtualisation.docker.enable = true;

  # Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  programs.starship = {
    presets = [
      "nerd-font-symbols"
    ];
  };

  # Audio (the rest is configured in the nixos-hardware module)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Authentication
  # Lock Screen
  #programs.swaylock.enable = true;
  # Display Manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      #--sessions ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions:${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --asterisks --remember --time --cmd ${swayfxPkg}/bin/sway";
      user = "greeter";
    };
  };
  # Fingerprint Auth
  services.fprintd.enable = true;
  security.pam.services = {
    greetd.fprintAuth = true;
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    swaylock.fprintAuth = true;
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
