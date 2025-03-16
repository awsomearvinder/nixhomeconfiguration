let
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN4p7cXNunFAdu1T0Mo9kiuUPE3lf/72fS+Akl/iWP9F";
in {
  "k3sToken.age".publicKeys = [ desktop ];
}
