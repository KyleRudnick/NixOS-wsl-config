{
  config,
  pkgs,
  pkgs-unstable,
  zellij-nightly,
  system,
  ...
}:
{
  # programs.zellij = {
  #   enable = true;
  #   package = pkgs.zellij;
  # };

  # environment.systemPackages = [
  #   zellij-nightly.packages.${system}.default
  # ];
  home.file.".config/zellij/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixOS/dotfiles/zellij/config.kdl";

  home.file.".config/zellij/layouts".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixOS/dotfiles/zellij/layouts";
}
