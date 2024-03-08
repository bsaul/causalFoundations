{
  description = "Causal Foundations";
  nixConfig = {
    bash-prompt = "λ ";
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.documents.intension = pkgs.stdenv.mkDerivation {
        name = "intension";
        src = ./.;
        buildInputs = [pkgs.pandoc];
        buildPhase = ''
        ${pkgs.pandoc}/bin/pandoc --from=markdown \
            -o intension.docx \
            intension.md
        
        '';
        installPhase = ''
        mkdir -p $out
        cp intension.docx $out
        '';
      };
      devShells.default =  pkgs.mkShell {
        buildInputs = [
          # Documentation/writing tools
          pkgs.pandoc
        ];
      }; 
    });
}