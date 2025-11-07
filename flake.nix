{
  description = "help";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    opencode-flake.url = "github:aodhanhayter/opencode-flake";
    claude-code.url = "github:sadjow/claude-code-nix";
    swayfx = {
      url = "github:/WillPower3309/swayfx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    terminal-rain-lightning = {
      url = "path:./pkgs/terminal-rain-lightning";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm = {
      url = "github:duhby/wezterm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    ...
  } @ inputs: {
    nixosConfigurations = {
      # F13 Laptop
      nivalis =
        nixpkgs.lib.nixosSystem
        {
          system = "x86_64-linux";
          modules = [
            ./hosts/nivalis
            nixos-hardware.nixosModules.framework-12th-gen-intel
          ];
          specialArgs = {
            inherit inputs;
          };
        };
    };
  };
}
