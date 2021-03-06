# Colored prompt stands out in the sea of text, which makes it _much_ easier
# to navigate through the terminal output.

# Define vars with color codes - may be handy for other things, too
BOLD="\033[1;37m"
DIM="\033[2m"
NORMAL="\033[21m"

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
DEFAULT="\033[39m"

BR_RED="\033[91m"
BR_GREEN="\033[92m"
BR_YELLOW="\033[93m"
BR_BLUE="\033[94m"
BR_MAGENTA="\033[95m"
BR_CYAN="\033[96m"
BR_WHITE="\033[97m"
BR_DEFAULT="\033[99m"

RESET_COLOR="\033[0m"

# Using \[ and \] around color codes in prompt is necessary to prevent strange issues!
PS1_PATH_COLOR="${CYAN}"
PS1_RESET_COLOR="\[${RESET_COLOR}\]"

if [ $EUID = 0 ]; then
    PS1_USER_COLOR="${RED}"
fi

# Display host name and use different color when I'm logged in via ssh
if [ -n "$SSH_CONNECTION" ]; then
    PS1_USER_COLOR="${MAGENTA}"
    PS1_USERNAME='\u@\h'
else
    PS1_USER_COLOR="${BLUE}"
    PS1_USERNAME='\u'
fi

# Show notification when the shell was lauched from ranger
PS1_RANGER_COLOR="\[${BLUE}\]"
[ -n "$RANGER_LEVEL" ] && ranger_notice=" ${PS1_RANGER_COLOR}(in ranger)${PS1_RESET_COLOR}"

smartdollar="\\$ \[${BOLD}\]"

# $(__git_ps1) displays git repository status in the prompt, which is extremely handy.
# Read more: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="verbose git"

ssh_normalize_key_names() {
  for name in "$@"; do
    if [ -e "$name" ]; then
      basename "$name"
    else
      echo "$name"
    fi
  done
}

check_ssh_keys() {
  if [ -S $SSH_AUTH_SOCK ]; then
    if key_listing=$(ssh_normalize_key_names $(set -o pipefail; ssh-add -l | cut -d' ' -f3)); then
      echo $key_listing | sed 's/$/ /'
    fi
  else
    echo "(no ssh agent) "
  fi
}
# set defaults so that we don't have uninitialized variables
: ${GIT_PS1_FMT:=""}

# wrap PS1_USER_COLOR inside an echo call so that it will be evaluated on every command
# (so that I can dynamically change the color just by changing the variable).
export PS1="\$(echo -e \${PS1_PATH_COLOR})\w\
${PS1_RESET_COLOR}\
\$(__git_ps1 \"\$GIT_PS1_FMT\")\
${ranger_notice}\n${smartdollar}"

export PS4="$(tput bold)>>> $(tput sgr0)"

# simpler prompt for git beginner workshops
simple_prompt() {
  export PS1="\$(echo -e \${PS1_PATH_COLOR})\w${PS1_RESET_COLOR}\n${smartdollar}"
}


#reset color
trap "tput sgr0" DEBUG

