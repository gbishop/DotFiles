DEST=/home/gb/dotfiles/vim
build:
	docker build --rm=true -t vim .
	docker run -v $(DEST):/dest -t vim /bin/bash /vim/build.sh $(DEST)
