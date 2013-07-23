#!/bin/bash -
set -o nounset

declare output=${TMP}/known_hosts

declare -A hosts ports
hosts=([0]=217.91.237.66 [1]=217.91.237.66 [2]=217.91.48.156 [3]=78.47.110.141
[4]=78.47.233.37 [5]=88.198.178.36 [6]=88.198.72.204 [7]=auto-stauzebach.de
[8]=fresno053.server4you.de [9]=git.renatius.net [10]=github.com
[11]=himalia.renatius.net [12]=login.mathematik.uni-marburg.de
[13]=lysithea.renatius.net [14]=pasiphae.renatius.net
[15]=puck312.server4you.de [16]=204.232.175.90)

ports=([0]=2225 [1]=2226 [2]=22 [3]=2222 [4]=2222 [5]=2222 [6]=2222 [7]=22
[8]=22 [9]=2222 [10]=22 [11]=2222 [12]=22 [13]=2222 [14]=2222 [15]=22 [16]=22)

[ -e ${output} ] && rm ${output}
for ((i = 0; i < ${#hosts}; i++)); do
    ssh-keyscan -H -t dsa,ecdsa,rsa -p ${ports[${i}]} ${hosts[${i}]} >> ${output}
done
sort -u -o ~/.ssh/known_hosts ${output}
