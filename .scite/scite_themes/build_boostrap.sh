#!/bin/bash

out=''

for prop in $(ls ./langs/*.properties); do
    out=${out}$(echo 'import .scite/scite_themes/langs/'${prop} | sed 's/\.properties//g' | sed 's/\.\/langs\///g')'\n'
done
echo -e ${out} > ./bootstrap.properties
