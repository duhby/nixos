{
  description = "help";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ...}@inputs: {
    nixosConfigurations = {
      # F13 Laptop
      nivalis = nixpkgs.lib.nixosSystem
        {
          system = "x86_64-linux";
          modules = [
            ./hosts/nivalis/configuration.nix
	    nixos-hardware.nixosModules.framework-12th-gen-intel
          ];
        };
    };
  };
}
