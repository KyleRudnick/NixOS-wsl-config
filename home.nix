{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  pkgs,
  username,
  nix-index-database,
  inputs,
  config,
  ...
}: let
  linux-build-env = pkgs.buildFHSEnv {
    name = "build-env"; # This becomes the actual command you type in the terminal
    
    targetPkgs = pkgs: with pkgs; [
      # C/C++ Build tools
      stdenv.cc
      gnumake
      cmake
      pkg-config
      autoconf
      automake


      # Rust toolchain installer
      rustup

      # Common libraries for Rust -sys crates
      openssl
      openssl.dev
      zlib
      zlib.dev
      glib
      glib.dev
    ];

    # Set up environment variables
    profile = ''
      export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
    '';

    # What to run when you type the command
    runScript = "bash";
  };

  unstable-packages = with pkgs.unstable; [
    bat
    bottom
    coreutils
    curl
    dust
    fd
    findutils
    fx
    git
    git-crypt
    gemini-cli
    htop
    jq
    killall
    mosh
    neovim
    opencode
    procs
    ripgrep
    sd
    tmux
    tree
    unzip
    vim
    wget
    zip
    zellij
  ];

  stable-packages = with pkgs; [

    # tools 
    
    # key tools
    gh # for bootstrapping
    just

    # local dev stuf
    mkcert
    httpie

    # treesitter
    tree-sitter

    # language servers
    nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.yaml-language-server
    nil # nix

    # formatters and linters
    alejandra # nix
    deadnix # nix
    nodePackages.prettier
    shellcheck
    shfmt
    statix # nix
  ];
in {
  imports = [
    nix-index-database.homeModules.nix-index
    ./modules
    inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    # Path to your private key
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    
    # Path to your encrypted secrets file
    defaultSopsFile = ./secrets.yaml;
    
    # Define the secret you want to manage
    secrets.OPENROUTER_API_KEY = { };
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    stateVersion = "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "/etc/profiles/per-user/${username}/bin/fish";
      OPENROUTER_API_KEY = "$(cat ${config.sops.secrets.OPENROUTER_API_KEY.path})";
    };
  };


  home.packages =
    stable-packages
    ++ unstable-packages
    ++ [ linux-build-env ]
    ++

    # FIXME: you can add anything else that doesn't fit into the above two lists in here
    [
      # pkgs.some-package
      # pkgs.unstable.some-other-package
    ];

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableFishIntegration = true;
    nix-index-database.comma.enable = true;

    fzf.enable = true;
    fzf.enableFishIntegration = true;
    lsd.enable = true;
    zoxide.enable = true;
    zoxide.enableFishIntegration = true;
    zoxide.options = ["--cmd cd"];
    broot.enable = true;
    broot.enableFishIntegration = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
    };
    git = {
      enable = true;
      package = pkgs.unstable.git;
      settings.user.email = "rudnick.kyle@gmail.com";
      settings.user.name = "kyle"; 
        # FIXME: uncomment the next lines if you want to be able to clone private https repos
        # url = {
        #   "https://oauth2:${secrets.github_token}@github.com" = {
        #     insteadOf = "https://github.com";
        #   };
        #   "https://oauth2:${secrets.gitlab_token}@gitlab.com" = {
        #     insteadOf = "https://gitlab.com";
        #   };
        # };
      };
fish = {
      enable = true;
      # FIXME: run 'scoop install win32yank' on Windows, then add this line with your Windows username to the bottom of interactiveShellInit
      # fish_add_path --append /mnt/c/Users/<Your Windows Username>/scoop/apps/win32yank/0.1.1
      interactiveShellInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

        ${pkgs.lib.strings.fileContents (pkgs.fetchFromGitHub {
            owner = "rebelot";
            repo = "kanagawa.nvim";
            rev = "de7fb5f5de25ab45ec6039e33c80aeecc891dd92";
            sha256 = "sha256-f/CUR0vhMJ1sZgztmVTPvmsAgp0kjFov843Mabdzvqo=";
          }
          + "/extras/kanagawa.fish")}

        set -U fish_greeting
        set -g fish_key_bindings fish_vi_key_bindings
      '';
      functions = {
        refresh = "source $HOME/.config/fish/config.fish";
        take = ''mkdir -p -- "$1" && cd -- "$1"'';
        ttake = "cd $(mktemp -d)";
        show_path = "echo $PATH | tr ' ' '\n'";
        posix-source = ''
          for i in (cat $argv)
            set arr (echo $i |tr = \n)
            set -gx $arr[1] $arr[2]
          end
        '';
      };
      shellAbbrs =
        {
          gc = "nix-collect-garbage --delete-old";
          fr = "sudo nixos-rebuild switch --flake .";
          fu = "nix flake update";
        }
        # navigation shortcuts
        // {
          ".." = "cd ..";
          "..." = "cd ../../";
          "...." = "cd ../../../";
          "....." = "cd ../../../../";
        }
        # git shortcuts
        // {
          gapa = "git add --patch";
          grpa = "git reset --patch";
          gst = "git status";
          gdh = "git diff HEAD";
          gp = "git push";
          gph = "git push -u origin HEAD";
          gco = "git checkout";
          gcob = "git checkout -b";
          gcm = "git checkout master";
          gcd = "git checkout develop";
          gsp = "git stash push -m";
          gsa = "git stash apply stash^{/";
          gsl = "git stash list";
        };
      shellAliases = {
        v = "nvim";
        jvim = "nvim";
        lvim = "nvim";
        pbcopy = "/mnt/c/Windows/System32/clip.exe";
        pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
        explorer = "/mnt/c/Windows/explorer.exe";
        
        # To use code as the command, uncomment the line below. Be sure to replace [my-user] with your username. 
        # If your code binary is located elsewhere, adjust the path as needed.
        # code = "/mnt/c/Users/[my-user]/AppData/Local/Programs/'Microsoft VS Code'/bin/code";
      };
      plugins = [
        {
          inherit (pkgs.fishPlugins.autopair) src;
          name = "autopair";
        }
        {
          inherit (pkgs.fishPlugins.done) src;
          name = "done";
        }
        {
          inherit (pkgs.fishPlugins.sponge) src;
          name = "sponge";
        }
      ];
    };
  };
}
