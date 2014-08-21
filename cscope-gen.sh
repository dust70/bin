#!/bin/bash
for arg in "${@}"; do
    if [ -d ${arg}  ]; then
        find ${arg} \
            -iname "*.c" \
            -or -iname "*.cc" \
            -or -iname "*.cpp" \
            -or -iname "*.h" \
            -or -iname "*.hpp"  \
            -or -iname "*.java" \
            -or -iname "*.php" \
            -or -iname "*.py" \
            -or -iname "*.tpl" \
            > ${arg}/cscope.files

        cscope -b -q -i ${arg}/cscope.files -f ${arg}/cscope.out
        rm -f ${arg}/cscope.files
    else
        echo "Directory not found: ${arg}"
    fi
done
