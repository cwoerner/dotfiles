alias lsl='ls -laFtr'

alias devpod-provider-options='devpod provider options devpod-pro'
alias devpod-version='devpod version'
alias devpod-upgrade='sudo devpod upgrade'
alias devpod-provider-reconfigure='devpod provider set-options devpod-pro --reconfigure'
alias devpod-disable-docker-credentials='devpod context set-options default -o SSH_INJECT_DOCKER_CREDENTIALS=false'

alias git-current-branch='git rev-parse --abbrev-ref HEAD'
alias git-root='git rev-parse --show-toplevel'

function bazel-path {
    _pwd="${PWD}/";
    _git_root="$(git-root 2>/dev/null)/"
    _dir=$(dirname "//${_pwd#$_git_root}x")
    if [ "$_dir" == "/" ]; then
       _dir="//"
    fi
    echo $_dir
}

function bazel-show-targets {
    # bazel query "attr(visibility, "//visibility:private", //path/to/thing:*)"
    bazel query "attr(visibility, "//visibility:private", ${1}:*)"
}

function bazel-show-deps {
    # bazel query "visible(//path/to/thing:py_test, ...)"
    bazel query "visible($1, ...)"
}

alias bazel-pytest='bazel test $(bazel-path):py_test'
alias bazel-flake8='bazel run $(bazel-path):py_lint_flake8'
alias bazel-pylint='bazel run $(bazel-path):py_lint_pylint'
alias bazel-mypy='bazel run $(bazel-path):mypy'
alias bazel-pytest-debug='bazel run $(bazel-path):py_test_debug'

alias bf=bazel-flake8
alias bl=bazel-pylint
alias bt=bazel-pytest
alias bm=bazel-mypy
alias bd=bazel-pytest-debug

# nvm
if [[ ! -d $HOME/.nvm || ! -f $HOME/.nvm/nvm.sh ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

cdnvm() {
    command cd "$@" || return $?
    nvm_path="$(nvm_find_up .nvmrc | command tr -d '\n')"

    # If there are no .nvmrc file, use the default nvm version
    if [[ ! $nvm_path = *[^[:space:]]* ]]; then

        declare default_version
        default_version="$(nvm version default)"

        # If there is no default version, set it to `node`
        # This will use the latest version on your machine
        if [ $default_version = 'N/A' ]; then
            nvm alias default node
            default_version=$(nvm version default)
        fi

        # If the current version is not the default version, set it to use the default version
        if [ "$(nvm current)" != "${default_version}" ]; then
            nvm use default
        fi
    elif [[ -s "${nvm_path}/.nvmrc" && -r "${nvm_path}/.nvmrc" ]]; then
        declare nvm_version
        nvm_version=$(<"${nvm_path}"/.nvmrc)

        declare locally_resolved_nvm_version
        # `nvm ls` will check all locally-available versions
        # If there are multiple matching versions, take the latest one
        # Remove the `->` and `*` characters and spaces
        # `locally_resolved_nvm_version` will be `N/A` if no local versions are found
        locally_resolved_nvm_version=$(nvm ls --no-colors "${nvm_version}" | command tail -1 | command tr -d '\->*' | command tr -d '[:space:]')

        # If it is not already installed, install it
        # `nvm install` will implicitly use the newly-installed version
        if [ "${locally_resolved_nvm_version}" = 'N/A' ]; then
            nvm install "${nvm_version}";
        elif [ "$(nvm current)" != "${locally_resolved_nvm_version}" ]; then
            nvm use "${nvm_version}";
        fi
    fi
}

alias cd='cdnvm'
cdnvm "$PWD" || exit

if [[ ! -d $HOME/.pyenv ]]; then
    curl -fsSL https://pyenv.run | bash
fi    
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

if [[ ! -d $HOME/.sdkman ]]; then
    curl -s "https://get.sdkman.io" | bash
fi
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
