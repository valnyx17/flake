{
  homeImports,
  inputs,
  self,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  modules = "${self}/modules/system";
  profiles = "${self}/hosts/profiles";

  specialArgs = {inherit inputs self;};
in {
  flake.nixosConfigurations = {
    laptop = nixosSystem {
      inherit specialArgs;

      modules = [
        ./laptop

        "${modules}/config"
        "${modules}/programs"
        "${modules}/security"
        "${modules}/services"
        "${modules}/virtualisation/docker.nix"
        "${profiles}/gnome"

        {
          home-manager = {
            users.kyodev.imports = homeImports."kyodev@laptop";
            extraSpecialArgs = specialArgs;
          };
        }
      ];
    };
  };
}
