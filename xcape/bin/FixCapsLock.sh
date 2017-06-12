#!/bin/bash

# make Caps lock an additional control key
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:ctrl_modifier']"
# tap Caps lock to get escape
xcape -e 'Caps_Lock=Escape'
