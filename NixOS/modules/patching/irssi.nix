
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      irssi = pkgprev.irssi.overrideAttrs (oldAttrs:
        let
          deps = with pkgprev.perlPackages; [
            EncodeLocale
            Clone
            HTTPDate
            HTTPMessage
            LWP
            LWPUserAgent
            LWPProtocolHttps
            CryptSSLeay
            NetSSLeay
            NetHTTP
            IOSocketSSL
            URI
            StringShellQuote
            TextSprintfNamed
            TryTiny
          ];
        in {
          # Add all packages as build inputs, including makeWrapper which we
          # will use in the postFixup hook.
          nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.makeWrapper ];# ++ deps;
          buildInputs = oldAttrs.buildInputs ++ [ pkgs.makeWrapper ] ++ deps;

          # Prepend all of the Perl package's paths to the Perl include path (@INC)
          # using ':' as a string separator
          postInstall = ''
            wrapProgram "$out/bin/irssi" --set PERL5LIB "$out/${pkgprev.perlPackages.perl.libPrefix}:${pkgprev.perlPackages.makePerlPath deps}"
          '';
        }
      );
    }
  )];
}

