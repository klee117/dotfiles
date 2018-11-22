# dotfiles

### list of bash dotfiles to change:
- inputrc
- bash_alias
- profile 
- vimrc
- tmux.config


### upgrade to vim 8
```sh
sudo add-apt-repository ppa:jonathonf/vim && \
sudo apt update && \
sudo apt install vim

(uninstall if needed) sudo apt install ppa-purge && sudo ppa-purge ppa:jonathonf/vim
```

### fix esckey deplay
in .vimrc
set timeoutlen=1000 ttimeoutlen=10

### install pathegon
```sh
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
```

### install fzf
```sh
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
~/.fzf/install && \
cd ~/.vim/bundle && \
git clone https://github.com/junegunn/fzf.vim
```

### gruvbox colorscheme
```sh
git clone https://github.com/morhetz/gruvbox.git ~/.vim/pack/default/start/gruvbox
```

### lightline (vim status bar)
```sh
git clone https://github.com/itchyny/lightline.vim ~/.vim/bundle/lightline.vim
```

### splitjoin.vim
```sh
git clone git://github.com/AndrewRadev/splitjoin.vim.git ~/.vim/bundle/splitjoin
```

### ultisnips
```sh 
git clone https://github.com/sirver/ultisnips ~/.vim/bundle/ultisnips
```

### vim-go
```sh
git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go
```

### tmux
```sh
sudo apt update && \
sudo apt install -y git && \
sudo apt install -y automake && \
sudo apt install -y build-essential && \
sudo apt install -y pkg-config && \
sudo apt install -y libevent-dev && \
sudo apt install -y libncurses5-dev

mkdir /tmp/tmux && \
git clone https://github.com/tmux/tmux.git /tmp/tmux  && \
cd /tmp/tmux && \
sh autogen.sh && \
./configure && make && \
sudo make install && \
cd ~/ && \
rm -fr /tmp/tmux
```

### The Silver Searcher (ag and ack.vim)
```sh
sudo apt install silversearcher-ag
git clone https://github.com/mileszs/ack.vim.git ~/.vim/bundle/ack.vim
```

### tmux vim navigation
```sh
cd ~/.vim/bundle && \
git clone https://github.com/christoomey/vim-tmux-navigator
```

### tslime.vim for sending command between vim and tmux
```sh
cd ~/.vim/bundle && \
git clone https://github.com/jgdavey/tslime.vim
```
### auto completing parenthesis and brackets
```sh
cd ~/.vim/bundle && \
git clone https://github.com/jiangmiao/auto-pairs
```

### python plugins
```sh
cd ~/.vim/pack/plugins/start && \
git clone --recursive https://github.com/python-mode/python-mode.git && \
cd ~/.vim/pack/plugins/start/python-mode && \
git submodule update --init --recursive
```

### fxing vim8 help tags (:help some_plugins doesn't work without this)
```sh
sudo vim
:helptags ALL
```
