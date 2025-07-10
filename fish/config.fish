if status is-interactive
    set -x PAGER less
    set -x LESS -R
    set -gx EDITOR nvim
    set -U fish_greeting ""
    starship init fish | source
    neofetch # Commands to run in interactive sessions can go here
end
