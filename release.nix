{ pinPackages ? false }:

let
  pinpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);
  src = builtins.fetchTarball {
    inherit (pinpkgs) sha256;
    url = "https://github.com/NixOS/nixpkgs/archive/${pinpkgs.rev}.tar.gz";
  };
  pkgs = if  pinPackages then import src {} else import <nixpkgs> {};
  f = import ./default.nix;
  drv = pkgs.callPackage f {};
  nm = builtins.replaceStrings ["."] ["_"] drv.name;
in builtins.trace nm (if pkgs.lib.inNixShell then drv else { ${nm} = drv; })


