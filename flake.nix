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

          (pkgs.agda.withPackages (p: [
              (p.standard-library.overrideAttrs (oldAttrs: {
                version = "2.0";
                src = pkgs.fetchFromGitHub {
                  repo = "agda-stdlib";
                  owner = "agda";
                  rev = "v2.0";
                  # sha256 = pkgs.lib.fakeSha256;
                  sha256 = "TjGvY3eqpF+DDwatT7A78flyPcTkcLHQ1xcg+MKgCoE=";
                };
              }))
        ]))


          # Documentation/writing tools
          pkgs.pandoc
        ];
      }; 
    });
}
