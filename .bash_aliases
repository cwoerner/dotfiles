alias lsl='ls -laFtr'

alias syncthing-get-alias='syncthing cli show system | jq -r .myID'
alias syncthing-start='brew services start syncthing'
alias syncthing-stop='brew services stop syncthing'

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
