DEST=/home/gb/dotfiles/tmux
build:
	docker build --rm=true -t tmux .
	docker run -v $(DEST):/dest -t tmux /bin/bash /tmux/build.sh $(DEST)
