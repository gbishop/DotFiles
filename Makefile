deploy: xcape/bin/xcape vim/bin/vim tmux/bin/tmux
	stow bash fonts git theme tmux vim xcape yank SwapDisplays python st cheatsheet pass

xcape/bin/xcape: src/xcape/xcape.c
	cd src/xcape; make install

push:
	rsync -a /home/gb/dotfiles/ gbserver3:dotfiles
	ssh gbserver3 'cd dotfiles; make deploy'
	rsync -a --no-group /home/gb/dotfiles/ gbserver2:dotfiles
	ssh gbserver2 'cd dotfiles; make deploy'
