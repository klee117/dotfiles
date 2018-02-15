# dotfiles

1. upgrade to vim 8
    sudo add-apt-repository ppa:jonathonf/vim
	sudo apt update
	sudo apt install vim
	(uninstall if needed) sudo apt install ppa-purge && sudo ppa-purge ppa:jonathonf/vim

1.1 fix esckey deplay
   in .vimrc
   set timeoutlen=1000 ttimeoutlen=10

2. install pathegon
   mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

3. install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

3.1 cd ~/.vim/bundle
git clone https://github.com/junegunn/fzf.vim

4. copy vim colors file
	git clone https://github.com/NLKNguyen/papercolor-theme
	cp papercolor-theme/colors/PaperColor.vim .vim/colors/

5. copy .vimrc file
	git clone https://github.com/klee117/dotfiles
	cp vim/.vimrc .

6. lightline (vim status bar)
	git clone https://github.com/itchyny/lightline.vim ~/.vim/bundle/lightline.vim

7. splitjoin.vim
   git clone git://github.com/AndrewRadev/splitjoin.vim.git ~/.vim/bundle/splitjoin

8. ultisnips
	git clone https://github.com/sirver/ultisnips ~/.vim/bundle/ultisnips

9. vim-go
	git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go

10. tmux
	sudo apt update
	sudo apt install -y git
	sudo apt install -y automake
	sudo apt install -y build-essential
	sudo apt install -y pkg-config
	sudo apt install -y libevent-dev
	sudo apt install -y libncurses5-dev

	rm -fr /tmp/tmux
	git clone https://github.com/tmux/tmux.git /tmp/tmux
	cd /tmp/tmux
	sh autogen.sh
	./configure && make
	sudo make install
	cd -
	rm -fr /tmp/tmux

11. The Silver Searcher (ag and ack.vim)
	sudo apt install silversearcher-ag
	git clone https://github.com/mileszs/ack.vim.git ~/.vim/bundle/ack.vim
	
12.
	using ag with vim 
	in .vimrc:
	let g:ackprg = 'ag --nogroup --nocolor --column'
	
13.
	tmux config
	bash alias tmux to tmux -2 (running 256 color) 
	
	put the following into .tmux.config
	
	use C-f, since it's on the home row and easier to hit than C-b
	set-option -g prefix C-f
	unbind-key C-f
	bind-key C-f send-prefix

	Easy config reload
	bind-key R source-file ~/.tmux.conf \; display-message "tmux.conf reloaded."

	vi is good
	setw -g mode-keys vi

	fix escape deplay
	set -s escape-time 0

	mouse behavior
	set -g mouse on

14. tmux vim navigation
    https://github.com/christoomey/vim-tmux-navigator
	
list of dotfiles changed:
.vimrc
.inputrc
.bash_alias

15. default vim as editor for things like postgresSQL /e  
    sudo update-alternatives --config editor
