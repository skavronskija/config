# dotfiles

Repo -> this machine:
```bash
./bootstrap.sh            # prompts before overwriting files in ~
./bootstrap.sh --force
```

This machine -> repo:
```bash
./gather.sh --dry-run     # report only
./gather.sh               # prompts before overwriting repo files
./gather.sh --force
```

`gather.sh` syncs whole directories back from `$HOME`, so newly created config files
show up as untracked in `git status` for you to `git add` - it is not limited to paths
already tracked in the repo. Which directories get synced is derived from the repo
layout: a repo directory that directly contains files is synced recursively, one that
does not is only descended into, so e.g. `~/.config` itself is never taken wholesale.
Exclusions live in `.gatherignore`, using the same pattern syntax as `.gitignore`.
Files are compared by content, so identical files are left completely untouched.
Nothing is ever deleted, and anything not present on this machine is reported as
`missing` and skipped, so the same repo works on Linux and macOS. Review with `git diff`
and commit yourself - the script never commits.

# common
```bash
sudo apt update && \
sudo apt install tldr fzf duf mc ncdu tmux vim git htop python3 lnav bash-completion rsync bat neofetch speedtest-cli -y
```

make `batcat` a `bat` in debian  
```bash
mkdir -p ~/.local/bin && ln -s /usr/bin/batcat ~/.local/bin/bat
```

# zsh
```bash
sudo apt install fish 
```

# fish
```bash
sudo apt install fish 

fisher install jethrokuan/fzf
```

# vimconfig

```bash
:PlugInstall
```

# ssh keygen
```bash
ssh-keygen -t rsa -C "your_email@example.com"
```

# ctop
```bash
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.3/ctop-0.7.3-linux-amd64 -O /usr/local/bin/ctop 
sudo chmod +x /usr/local/bin/ctop
```

# lazydocker
```bash
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
```

# docker
Remove images without tags
```bash
docker rmi $(docker images -qa -f 'dangling=true')
```
