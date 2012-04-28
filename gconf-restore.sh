#!/bin/bash
[ ! -d .git ] && exit 0

DUMP=gconf

for f in $(find ${DUMP} -type f -name '*.xml'); do
    gconftool-2 --load=${f}
done
