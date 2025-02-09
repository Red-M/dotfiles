
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  nixpkgs.overlays = [(pkgfinal: pkgprev:
    {
      irssi_plugins = pkgs.symlinkJoin {
        name = "irssi_plugins";
        paths = [ pkgprev.irssi ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram "$out/bin/irssi" --set PERL5LIB "$out/${pkgprev.perlPackages.perl.libPrefix}:${pkgprev.perlPackages.makePerlPath (with pkgprev.perlPackages; [
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
          ])}"
        '';
      };
    }
  )];
}

