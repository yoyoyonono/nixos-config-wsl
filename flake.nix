{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    vscode-remote-workaround.url = "github:K900/vscode-remote-workaround/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, nix-flatpak, nixos-wsl, vscode-remote-workaround, ... }@inputs:
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [ 
            ./configuration.nix
            inputs.home-manager.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            nixos-wsl.nixosModules.default {
              system.stateVersion = "24.05";
              wsl.enable = true;
            }
            vscode-remote-workaround.nixosModules.default
          ];
        };
    };
}
