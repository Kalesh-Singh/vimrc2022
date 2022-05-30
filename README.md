# Installing the coc.nvim client

### Update Vim to (8.2+)

```
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update
sudo apt install vim
vim --version
```

### Update Node Js (12.0+)

```
curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt install nodejs
node -v
```

# Installing CCLS Server

```
sudo apt install snap
snap install --classic ccls
```

# Generate compile_commands.json

### Install Bear

```
sudo apt install bear
bear --version
```

### Compile the project with bear

```
cd linux
make -j`nproc` defconfig
bear make -j`nproc`
```
