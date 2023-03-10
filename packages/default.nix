{
  self,
  pkgs,
  ...
} @ inputs: rec {
  proton-ge-custom = pkgs.callPackage ./proton-ge-custom {};
}