#!/bin/bash
#set -x

# Get task command
TASK_COMMAND="task ${@}"

# Get data dir
DATA_RC=$(task show | grep data.location)
DATA=(${DATA_RC//=/ })
DATA_DIR=${DATA[1]}

# Call task, commit files and push if flag is set.
task $@
cd ${DATA_DIR}
git commit -a -m "${TASK_COMMAND}" > /dev/null
