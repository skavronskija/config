# common
```bash
sudo apt-get update && \
sudo apt-get install ncdu tmux vim git htop python3 maven bash-completion rsync -y
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

# docker
Remove images without tags
```bash
docker rmi $(docker images -qa -f 'dangling=true')
```
