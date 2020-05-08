#!/bin/bash
# https://github.com/nazoking/git-multi-ssh.sh/blob/master/git-multi-ssh.sh
# ssh deploy key manager for git command ( ex: for private submodules )
#
# `export GIT_SSH=git-multi-ssh.sh`
#
# and set environment valiable as `DEPLOY_KEY_[name]=[private-key]`
#
# - when repository ssh url is `git@github.com:nazoking/git-multi-ssh.sh.git`, then `DEPLOY_KEY_git_github_com_nazoking_git_multi_ssh_sh_git` ( replace all `[^0-9a-z]` to `_`(under bar))
# - `private-key` is private key for deploy
#
set -e

function normalize
{
  echo "$1"|sed -e "s/'//g" -e 's/[^0-9a-z]/_/g'
}


function mk_ssh_key
{
  local tmp="$(mktemp)"
  echo "$1" |perl -pe 's/\\n/\n/g' > "$tmp"
  chmod 0600 "$tmp"
  echo "$tmp"
}

function targets
{
  while [ $# -ne 0 ]
  do
    case "$1" in
    -[BbcDEeFIiJLlmOo])
      shift 2
      ;;
    -[46AaCfGgKkMNnqsTtVvXxYy]|-[BbcDEeFIiJLlmOo]*)
      shift
      ;;
    *)
      echo "$1"
      shift
    esac
  done
}

org=("$@")
t=($(targets "$@"))
case "${t[1]}" in
"git-upload-pack"|"git-receive-pack")
  h="DEPLOY_KEY_$(normalize "${t[0]}")_$(normalize "${t[2]}")"
  if [ -n "${!h}" ];then
    echo "[git-multi-ssh]use $h" >&2
    tmp=$(mk_ssh_key "${!h}")
    ssh -i "$tmp" "${org[@]}"
    ret=$?
    rm $tmp
    exit $ret
  else
    echo "[git-multi-ssh]not found $h" >&2
    ssh "${org[@]}"
  fi
  ;;
*)
  echo "[git-multi-ssh]unknwon ssh command ${@}" >&2
  ssh "$@"
esac
