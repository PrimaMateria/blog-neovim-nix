# vim: ft=vim
{ pkgs } : let
  ultisnipsSnippets = import ../../packages/ultisnipsSnippets.nix { inherit pkgs; };
in ''
  let g:UltiSnipsSnippetDirectories=["${ultisnipsSnippets}"]
''
