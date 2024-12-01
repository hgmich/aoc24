{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  # https://devenv.sh/packages/
  packages = with pkgs; [
    just
    janet
    jpm
    git
  ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  # scripts.hello.exec = ''
  #   echo hello from $GREET
  # '';

  enterShell = ''
    export JANET_PATH="$DEVENV_ROOT/jpm_tree/lib"
    export PATH="$DEVENV_ROOT/jpm_tree/bin:$PATH"
    jpm -l deps
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    judge
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;
  pre-commit.hooks.alejandra.enable = true;
  pre-commit.hooks.unit-tests = {
    enable = true;
    entry = "judge";
    files = "\\.janet$";
    pass_filenames = false;
  };

  # See full reference at https://devenv.sh/reference/options/
}
