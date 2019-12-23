#!/bin/bash
# ssh deploy key manager for git command ( ex: for private submodules )
#
# export GIT_SSH=git-multi-ssh.sh
#
# set environment valiable as `DEPLOY_KEY_[user_host]_[path]=[private-key]`
#
# - `user_host` is, if `git@team-lab.com` then `git_github_com`
# - `path` is, if `nazoking/git-multi-ssh.sh` then `nazoking_git_multi_ssh_sh`
#   replace all characters `[^0-9a-z]` to `_`
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
    echo "use $h"
    tmp=$(mktemp)
    echo "${!h}" > $tmp
    chmod 0600 $tmp
    ssh -i $tmp "${org[@]}"
    ret=$?
    rm $tmp
    exit $ret
  else
    echo "not found $h"
    ssh "${org[@]}"
  fi
else
  ssh "$@"
fi
