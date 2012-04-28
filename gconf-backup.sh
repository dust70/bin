#!/bin/bash

[ ! -d .git ] && exit 0

GCONF=~/.gconf
DUMP=gconf

[ ! -d "${GCONF}" ] && exit 0
[ ! -d "${DUMP}" ] && mkdir -p "${DUMP}"

for dir in $(find "${GCONF}" -mindepth 1 -type d); do
    subdir="${dir/${GCONF}}"
    mkdir -p "${DUMP}"/"${subdir}"
    gconftool-2 --dump "${subdir}" >| "${DUMP}"/"${subdir}"/"${subdir##*/}".xml
    touch "${DUMP}"/"${subdir}"/.gitignore
done

cp ~/.gtk-bookmarks gtk-bookmarks
