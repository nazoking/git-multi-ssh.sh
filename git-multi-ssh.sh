#!/bin/bash
# ssh deploy key manager for git command ( ex: for private submodules )
#
# `export GIT_SSH=git-multi-ssh.sh`
#
# and set environment valiable as `DEPLOY_KEY_[name]=[private-key]`
#
# - when repository ssh url is `git@github.com:nazoking/git-multi-ssh.sh.git`, then `DEPLOY_KEY_git_github_com_nazoking_git_multi_ssh_sh_git` ( replace all `[^0-9a-z]` to `_(under bar)`)
# - `private-key` is private key for deploy
#
set -e

function normalize
{
  echo "$1"|sed -e "s/'//g" -e 's/[^0-9a-z]/_/g'
}

if [ "${2%% *}" == "git-upload-pack" ];then
  org=("$@")
  set -- $2
  h="DEPLOY_KEY_$(normalize "${org[0]}")_$(normalize "$2")"
  if [ -n "${!h}" ];then
    echo "use $h" >&2
    tmp=$(mktemp)
    echo "${!h}" > $tmp
    chmod 0600 $tmp
    ssh -i $tmp "${org[@]}"
    ret=$?
    rm $tmp
    exit $ret
  else
    echo "not found $h" >&2
    ssh "${org[@]}"
  fi
else
  ssh "$@"
fi
