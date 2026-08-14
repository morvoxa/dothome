default:
  @just --list
home:
  home-manager switch --flake .#home -b backup
