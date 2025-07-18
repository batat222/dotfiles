if status is-interactive
    set source ~/.bashrc
    set -x PAGER less
    set -x LESS -R
    set -gx EDITOR nvim
    set -U fish_greeting ""
    eval (ssh-agent -c) >/dev/null
    starship init fish | source
    neofetch # Commands to run in interactive sessions can go here
end
