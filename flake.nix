{
  description = "help";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ...}@inputs: {
    nixosConfigurations = {
      # F13 Laptop
      nivalis = nixpkgs.lib.nixosSystem
        {
          system = "x86_64-linux";
          modules = [
            ./hosts/nivalis/configuration.nix
          ];
        };
    };
  };
}
