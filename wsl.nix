{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  username,
  hostname,
  pkgs,
  inputs,
  config,
  ...
}: {
  time.timeZone = "Europe/Berlin";

  networking.hostName = "${hostname}";

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    # Safely load the secrets into environment variables using standard shell paths
    if test -f "$XDG_RUNTIME_DIR/secrets/OPENROUTER_API_KEY"
      set -gx OPENROUTER_API_KEY (cat "$XDG_RUNTIME_DIR/secrets/OPENROUTER_API_KEY")
    end

    if test -f "$XDG_RUNTIME_DIR/secrets/OPENCODE_ZEN_GO_API_KEY"
      set -gx OPENCODE_ZEN_GO_API_KEY (cat "$XDG_RUNTIME_DIR/secrets/OPENCODE_ZEN_GO_API_KEY")
    end

    if test -f "$XDG_RUNTIME_DIR/secrets/github_token"
      set -gx GITHUB_TOKEN (cat "$XDG_RUNTIME_DIR/secrets/github_token")
    end

    if test -f "$XDG_RUNTIME_DIR/secrets/github_access_key"
      set -gx GITHUB_ACCESS_KEY (cat "$XDG_RUNTIME_DIR/secrets/github_access_key")
    end
  '';

  environment.pathsToLink = ["/share/fish"];
  environment.shells = [pkgs.fish];

  programs.zsh.enable = true;
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  services.gnome.gnome-keyring.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "docker"
      "kvm"
    ];
  };

  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  system.stateVersion = "25.11";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = username;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  nix = {
    settings = {
      trusted-users = [username];
      # FIXME: use your access tokens from secrets.json here to be able to clone private repos on GitHub and GitLab
      # access-tokens = [
      #   "github.com=${secrets.github_token}"
      #   "gitlab.com=OAuth2:${secrets.gitlab_token}"
      # ];

      accept-flake-config = true;
      auto-optimise-store = true;
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    package = pkgs.nixVersions.stable;
    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
