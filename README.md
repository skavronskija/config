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
