default:
    @just --list
home:
    home-manager switch --flake . -b backup
os:
    sudo nixos-rebuild switch --flake .
