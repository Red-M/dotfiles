#!/bin/bash

out=''

for prop in $(ls ./langauge_settings/*.properties); do
    out=${out}$(echo 'import .scite/custom/themes/langauge_settings/'${prop} | sed 's/\.properties//g' | sed 's/\.\/langauge_settings\///g')'\n'
done
echo -e ${out} > ./bootstrap.properties
