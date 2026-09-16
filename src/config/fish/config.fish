if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr -a ls "lsd -la"
    abbr -a cmt "$HOME/dothome/src/commit"
    starship init fish | source
    eval (direnv hook fish)
end
