# git_multi_ssh.sh

ssh deploy key manager for git command ( ex: for private submodules on github actions )

## usage

`export GIT_SSH=git-multi-ssh.sh`

and set environment valiable as `DEPLOY_KEY_[user_host]_[path]=[private-key]`


- `user_host` is, if `git@team-lab.com` then `git_github_com`
- `path` is, if `nazoking/git-multi-ssh.sh` then `nazoking_git_multi_ssh_sh`
  replace all characters `[^0-9a-z]` to `_`
- `private-key` is private key for deploy
