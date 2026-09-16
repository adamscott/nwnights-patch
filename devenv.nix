{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{

  # https://devenv.sh/basics/
  # env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    scons

    # LSPs.
    yaml-language-server

    # C
    clang
    clang-tools
  ];

  # https://devenv.sh/languages
  # languages.rust.enable = true;
  languages.c = {
    enable = true;
    lsp.enable = true;
  };

  languages.cplusplus = {
    enable = true;
    lsp.enable = true;
  };

  languages.python = {
    enable = true;
    package = pkgs.python3.withPackages (ps: [
      ps.distutils
      ps.ruff
      ps.pwntools
    ]);
    venv.enable = true;
    lsp = {
      enable = true;
      package = pkgs.basedpyright.overrideAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ pkgs.makeWrapper ];
        postInstall = (oldAttrs.postInstall or "") + ''
          makeWrapper $out/bin/basedpyright $out/bin/pyright --inherit-argv0
          makeWrapper $out/bin/basedpyright-langserver $out/bin/pyright-langserver --inherit-argv0
        '';
      });
    };
  };

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  # scripts.hello.exec = ''
  #   echo hello from $GREET
  # '';

  # https://devenv.sh/basics/
  # enterShell = ''
  #   hello         # Run scripts directly
  #   git --version # Use packages
  # '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  # enterTest = ''
  #   echo "Running tests"
  #   git --version | grep --color=auto "${pkgs.git.version}"
  # '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
