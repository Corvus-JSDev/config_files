if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting
set -x PATH $PATH /home/corvus_dev/.cargo/bin



alias ls="lsd --color always --icon always --group-dirs=last"
alias vim="nvim"
alias ll="ls -alh"
alias open="xdg-open"
alias update="echo Updating PACKAGES with: pacman -Syu && sudo pacman -Syu"
alias fullupdate="echo Full system update with: pacman -Syyu && sudo pacman -Syyu"
alias cp="cp -r"
alias shutdown="shutdown 0"










