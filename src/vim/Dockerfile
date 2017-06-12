from ubuntu:16.04

maintainer Gary Bishop <gb@cs.unc.edu>

run apt-get update
run DEBIAN_FRONTEND=noninteractive apt-get install libevent-dev ncurses-dev build-essential wget git -y
run DEBIAN_FRONTEND=noninteractive apt-get build-dep vim-gnome -y
run mkdir /vim
run git clone https://github.com/vim/vim.git /vim

add build.sh /vim/build.sh
