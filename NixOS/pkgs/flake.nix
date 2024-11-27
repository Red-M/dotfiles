{
  outputs = { self, nixpkgs }: {
    overlay = final: prev: { pipewire-module-xrdp = prev.pkgs.callPackage ./pipewire-module-xrdp { }; };

    packages.x86_64-linux.pipewire-module-xrdp = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pipewire-module-xrdp {};

  };
}

