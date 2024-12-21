if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

YELLOW="\e[43m\e[30m"
GREY="\e[47m\e[30m"
BLUE="\e[104m\e[97m"
PINK="\e[105m\e[97m"
BOLD="\e[01;97m"

COL_USER=$YELLOW
COL_HOST=$GREY
if [ "x$(hostname -d)" == "xlocal" ]; then
    COL_DIR=$PINK
else
    COL_DIR=$BLUE
fi
COL_NONE="\e[0m"
COL_GIT_PROJ=$COL_DIR
COL_GIT_BRANCH="${COL_DIR}${BOLD}"

export PS1='$(u=$(whoami);
       git_root="$(git-root 2>/dev/null)/";
       if [ "$git_root" != "/" ]; then
          git_branch=$(git-current-branch 2>/dev/null);
          printf "\[${COL_GIT_PROJ}\][%s>\[${COL_GIT_BRANCH}\]%s\[${COL_NONE}\]\[${COL_GIT_PROJ}\]]\[${COL_NONE}\]:%s" "$(basename "${git_root}")" "${git_branch}" "$(bazel-path)";
       else
           printf "\[${COL_USER}\]%s\[${COL_HOST}\]@\h:\[${COL_NONE}\]" "${u:0:4}..${u: -4}";
           if [[ "$PWD" == $HOME/* ]] || [[ "$PWD" == "$HOME" ]]; then
               printf "~%s" "${PWD#$HOME}";
           else
               printf "$PWD";
           fi
       fi;
       printf "\$ ")';
