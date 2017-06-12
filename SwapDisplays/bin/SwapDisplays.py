#!/usr/bin/python2
# from: https://bitbucket.org/antocuni/wmctrl/src

import os
from commands import getoutput
try:
    from collections import namedtuple
except ImportError:
    from namedtuple import namedtuple

BaseWindow = namedtuple('Window', 'id desktop pid x y w h wm_class host wm_name wm_window_role wm_state')

class Window(BaseWindow):

    @classmethod
    def list(cls):
        out = getoutput('wmctrl -l -G -p -x')
        windows = []
        for line in out.splitlines():
            parts = line.split(None, len(Window._fields)-3)
            parts = map(str.strip, parts)
            parts[1:7] = map(int, parts[1:7])
            parts.append(_wm_window_role(parts[0]))
            parts.append(_wm_state(parts[0]))
            windows.append(cls(*parts))
        return windows

    @classmethod
    def by_name(cls, name):
        return [win for win in cls.list() if win.wm_name == name]

    @classmethod
    def by_name_endswith(cls, name):
        return [win for win in cls.list() if win.wm_name.endswith(name)]

    @classmethod
    def by_name_startswith(cls, name):
        return [win for win in cls.list() if win.wm_name.startswith(name)]

    @classmethod
    def by_role(cls, role):
        return [win for win in cls.list() if win.wm_window_role == role]

    @classmethod
    def by_class(cls, wm_class):
        return [win for win in cls.list() if win.wm_class == wm_class]

    @classmethod
    def by_id(cls, id):
        return [win for win in cls.list() if int(win.id, 16) == id]

    @classmethod
    def get_active(cls):
        out = getoutput("xprop -root _NET_ACTIVE_WINDOW")
        parts = out.split()
        try:
            id = int(parts[-1], 16)
        except ValueError:
            return None
        lst = cls.by_id(id)
        if not lst:
            return None
        assert len(lst) == 1
        return lst[0]

    def activate(self):
        os.system('wmctrl -id -a %s' % self.id)

    def resize_and_move(self, x, y, w, h):
        mvarg = '0,%d,%d,%d,%d' % (x, y, w, h)
        os.system('wmctrl -i -r %s -e %s' % (self.id, mvarg))

    def set_geometry(self, geometry):
        dim, pos = geometry.split('+', 1)
        w, h = map(int, dim.split('x'))
        x, y = map(int, pos.split('+'))
        self.resize_and_move(x, y, w, h)

    def set_properties(self,properties):
        proparg = ",".join(properties)
        os.system('wmctrl -i -r %s -b %s' % (self.id,proparg))

def _wm_window_role(winid):
    out = getoutput('xprop -id %s WM_WINDOW_ROLE' % winid)
    try:
        _, value = out.split(' = ')
    except ValueError:
        # probably xprop returned an error
        return ''
    else:
        return value.strip('"')

def strip_prefix (prefix, word):
    if word.startswith(prefix):
        return word[len(prefix):]
    return word

def _wm_state (winid):
    out = getoutput('xprop -id %s _NET_WM_STATE' % winid)
    try:
        _, value = out.split(' = ')
    except ValueError:
        # probably xprop returned an error
        return []
    else:
        return [strip_prefix("_NET_WM_STATE_",s).lower()
                for s in value.split(', ')]

import sys
# my code begins here.
# goal is to move windows between my two HD res displays
for w in Window.list():
    if (len(sys.argv) > 1 and sys.argv[1] == '-t' and 
            "Gnome-terminal" not in w.wm_class and 
            "st-256color" not in w.wm_class):
        continue
    if w.wm_window_role or "st-256color" in w.wm_class: # only do real windows
        if w.y < 1080:
            w.resize_and_move(w.x, w.y+1080, w.w, w.h)
        else:
            w.resize_and_move(w.x, w.y-1080, w.w, w.h)
