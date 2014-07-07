#!/bin/bash
for arg in "$@"; do
    if [ -d $arg  ]; then
        #echo Create list of php files in cscope.files
        find $arg \( -name "*.php" -or -name "*.tpl" \) -and -not -regex "./temp/.*" -and -not -regex ".*/language.php" -print > $arg/cscope.files
        #echo Create cscope database in cscope.out
        cscope -b -i $arg/cscope.files -f$arg/cscope.out
        rm -f $arg/cscope.files
    else
        echo "Directory not found: $arg"
    fi
done
