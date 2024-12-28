alias lsl='ls -laFtr'

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
