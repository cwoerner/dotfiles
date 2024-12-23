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
    # bazel query "attr(visibility, "//visibility:private", //wayve/services/data/preprocessing/data_copier/gen2:*)"
    bazel query "attr(visibility, "//visibility:private", ${1}:*)"
}

function bazel-show-deps {
    # bazel query "visible(//wayve/services/data/preprocessing/data_copier/gen2:py_checks, ...)"
    bazel query "visible($1, ...)"
}
