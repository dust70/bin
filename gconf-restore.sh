#!/bin/bash
[ ! -d .git ] && exit 0

DUMP=gconf

gconftool-2 --recursive-unset /
[ -d ~/.gconf ] && rm -rf ~/.gconf

for f in $(find ${DUMP} -type f -name '*.xml'); do
    gconftool-2 --load=${f}
done

cp gtk-bookmarks ~/.gtk-bookmarks
