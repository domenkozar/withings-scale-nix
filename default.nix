let
  pkgs = import <nixpkgs> {};
in pkgs.stdenv.mkDerivation {
  name = "withings";

  src = pkgs.fetchurl {
    url = "http://fw.withings.net/pairingwizard_Linux_x86_64";
    sha256 = "03dx0l8zvakarx70rmb0fdpzw9b6bgdym1s2zh0r0iazs879disp";
  };
  
  buildInputs = with pkgs; [ upx patchelf ];

  buildCommand = ''
   upx -d $src -o pairingwizard
   chmod +xw pairingwizard

   patchelf \
     --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
     --set-rpath ${ with pkgs; with pkgs.xorg; stdenv.lib.makeLibraryPath [ zlib libX11 libXext libXrender fontconfig freetype stdenv.cc.cc.lib libXcursor libXrandr libXfixes ] } \
     pairingwizard

   mkdir -p $out/bin
   mv pairingwizard $out/bin/
  '';
}
