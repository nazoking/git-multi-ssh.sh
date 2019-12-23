# git_multi_ssh.sh

ssh deploy key manager for git command ( ex: for private submodules on github actions )

## usage

`export GIT_SSH=git-multi-ssh.sh`

and set environment valiable as `DEPLOY_KEY_[name]=[private-key]`


- when repository ssh url is `git@github.com:nazoking/git-multi-ssh.sh.git`, then `DEPLOY_KEY_git_github_com_nazoking_git_multi_ssh_sh_git` ( replace all `[^0-9a-z]` to `_(under bar)`)
- `private-key` is private key for deploy
