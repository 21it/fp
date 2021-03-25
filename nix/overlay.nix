let nixpkgs-latest = import (import ./nixpkgs-latest.nix) {};
in
{
  hexOrganization,
  hexApiKey,
  robotSshKey,
  vimBackground ? "light",
  vimColorScheme ? "PaperColor"
}:
[
  (
    self: super:
      {
        elixir = nixpkgs-latest.elixir;
        haskell-ide = import (
          fetchTarball "https://github.com/tim2CF/ultimate-haskell-ide/tarball/a3424a3100f9be4fa88603999db988bf87d91718"
        ) {inherit vimBackground vimColorScheme;};
      }
  )
]
