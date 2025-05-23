{
  description = "protobufjson";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          packageName = "protobufjson";
          version = "1.0.0";
          fs = pkgs.lib.fileset;
        in
        {
          packages = rec {
            default = protobufjson;
            protobufjson = pkgs.clangStdenv.mkDerivation
              {
                pname = "${packageName}";
                version = "${version}";
                src = ./.;
                nativeBuildInputs = with pkgs; [
                  gcc
                  gnumake
                  protobuf_21
                  abseil-cpp
                ];
                buildInputs = with pkgs; [
                  pkg-config
                  protobuf_21
                  abseil-cpp
                ];

                dontConfigure = true;
                buildPhase = ''
                  IN_NIX=1 NIX_LDFLAGS="$(pkg-config --libs protobuf) $NIX_LDFLAGS" NIX_CFLAGS_COMPILE="$(pkg-config --cflags protobuf) $NIX_CFLAGS_COMPILE" make -j $NIX_BUILD_CORES
                '';

                installPhase = ''
                  mkdir -p $out/bin
                  mv ProtoToJson $out/bin
                '';
              };
          };
        }
      );
}
