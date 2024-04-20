{
  inputs,
  lib,
  ...
}: let
  sharedModules = [
    ./modules/programs/git.nix
    ./modules/programs/gpg.nix
    ./modules/programs/ssh.nix
    ./modules/programs/starship.nix
    ./modules/programs/utils.nix
    ./modules/programs/zsh.nix
    ./modules/services/gnome-keyring.nix
    ./modules/services/sops.nix
  ];

  homeImports = {
    "kd@nori" =
      [
        ./home.nix
        ./profiles/gnome
      ]
      ++ lib.concatLists [sharedModules];
  };

  inherit (inputs.home-manager.lib) homeManagerConfiguration;
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  _module.args = {
    inherit homeImports;
  };

  flake = {
    homeConfigurations = {
      "kd@nori" = homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs;};
        inherit pkgs;
        modules = homeImports."kd@nori";
      };
    };
  };
}
