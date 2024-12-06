if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting
set -x PATH $PATH /home/corvus_dev/.cargo/bin

# Show a quick list of commonly used alias'
alias help="echo -e '
===== RC files ===== \n
ebash      # Edit bash \n
efish      # Edit fish \n
sfish      # Source fish \n
\n
===== Misc ===== \n
makeexe    # Make a file executable \n
md         # Reading markdown files \n
size       # Get the size of a file or dir \n
date       # Print the date \n
pipupdate  # Update all pip packages \n
cpp        # Copy with progress bar \n
cpg        # Copy and go to \n
\n
===== Quick movements ===== \n
desk       # Move to desktop \n
..         # Back one dir \n
../..       # Back two dirs \n
\n
===== Viewing quick info ===== \n
folders    # List folders only \n
tree       # Tree view \n
treed      # Tree with only folders \n
pwdtail    # Print the last two fields of the working dir' | less -R"


# === RC files ===
alias ebash='nvim ~/.bashrc'
alias efish='nvim ~/.config/fish/config.fish'
alias sfish='source ~/.config/fish/config.fish'
#alias sbash='source ~/.bashrc'

# === Basics ===
alias ls='ls -Fhx --color=always --group-directories-first'
#alias ls="lsd -F --color always --icon always --group-dirs=last"
alias ll="ls -FAlh --color=always"
alias la="ls -A"
alias cp="cp -ri"
alias sd="shutdown 0"
alias c='clear'
alias less='less -R'

# === Misc ===
alias update="sudo nala update && sudo nala upgrade"
alias makeexe="chmod +x"
alias md="glow -ps dark"  # Reading markdown files
alias size="du -sh"  # Get the size of a file or dir
alias date='date "+%Y-%m-%d %A %T %Z"'

# === Editors ===
alias vim="nvim"
alias vi="vim"

# === Look in the current dir for a file (or dir) ===
alias f="find . | grep "

# === Quick movements ===
alias home='cd ~'
alias desk='cd ~/Desktop/'
alias ..="cd .."

# Viewing quick info
alias folders='du -h --max-depth=1'
alias tree='tree -CAF --dirsfirst -L 2'
alias treed='tree -CAFd -L 2'

# Cleaning up unused docker containers, images, networks, and volumes
alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '





#######################################################
# SPECIAL FUNCTIONS
#######################################################

# Update all pip packages
function pipupdate
    set -l action $argv[1]
    set -l package_name $argv[2]

    switch $action
        case ''
            # List outdated packages
            set -l outdated_packages (pip list --outdated --format=freeze | cut -d = -f 1)
            if test -n "$outdated_packages"
                echo "Updating the following packages:"
                echo $outdated_packages
                # Update all packages
                echo $outdated_packages | xargs -n1 pip install -U
                echo "All packages updated."
            else
                echo "All packages are up-to-date."
            end
        case 'single'
            # Update a single package
            if test -n "$package_name"
                echo "Updating package '$package_name'..."
                pip install --upgrade $package_name
                echo "Package '$package_name' updated."
            else
                echo "Error: Please provide a package name when using 'single' option."
                return 1
            end
        case '*'
            echo "Usage: pipupdate [single <package_name>]"
            return 1
    end
end


# Copy command with progress bar
function cpp
    set -e
    set total_size (stat -c '%s' $argv[1])
    set count 0
    strace -q -ewrite cp -- $argv[1] $argv[2] 2>&1 | while read line
        set count (math $count + (echo $line | awk '{print $NF}'))
        if test (math $count % 10) -eq 0
            set percent (math $count / $total_size * 100)
            printf "%3d%% [" $percent
            for i in (seq 1 $percent)
                printf "="
            end
            printf ">"
            for i in (seq $percent 100)
                printf " "
            end
            printf "]\r"
        end
    end
    echo ""  # To print a newline after the progress bar
end


# Copy and go to
function cpg
    if test -d $argv[2]
        cp $argv[1] $argv[2]
        cd $argv[2]
    else
        cp $argv[1] $argv[2]
    end
end


# Automatically do ls after cd
function cd
    if test -n "$argv"
        builtin cd $argv; and ls
    else
        builtin cd ~; and ls
    end
end


# Returns the last 2 fields of the working directory
function pwdtail
    set pwd_parts (string split / (pwd))
    echo $pwd_parts[-2]"/"$pwd_parts[-1]
end





### Node Version Manager (NVM)
# The NVM is only avalable when using bash
# Switch to bash and run: $ nvm install node
# This will install the lastest version of node


