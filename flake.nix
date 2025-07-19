{
  description = "help";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    swayfx = {
      url = "github:/WillPower3309/swayfx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm = {
      url = "github:duhby/wezterm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, ...} @inputs: {
    nixosConfigurations = {
      # F13 Laptop
      nivalis = nixpkgs.lib.nixosSystem
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
