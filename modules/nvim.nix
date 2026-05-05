{
  pkgs,
  config,
  ...
}:
let

  treesitterWithGrammars = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.css
    p.dockerfile
    p.fish
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.javascript
    p.jq
    p.json5
    p.json
    p.lua
    p.make
    p.markdown
    p.markdown_inline
    p.nix
    p.python
    p.rust
    p.toml
    p.typescript
    p.vue
    p.yaml
    p.zig
  ]);

  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };
in
{
  home.packages = with pkgs; [
    lua-language-server
    yaml-language-server
    nixd
    vscode-langservers-extracted
    prettierd
    shfmt
    zls
    gopls
    copilot-language-server
    tinymist
    nodePackages_latest.typescript-language-server
  ];

  # Use the external dotfiles nvim config for quicker hacking
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixOS/dotfiles/nvim";

  programs.neovim = {
    enable = false;
    # package = pkgs-unstable.neovim;
    defaultEditor = true;
    vimAlias = true;
    plugins = [
      treesitterWithGrammars
    ];
  };

}
