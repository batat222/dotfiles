#! /bin/bash

bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

i=0
while [ $i -lt ${#bar} ]; do
  dict="${dict}s/$i/${bar:$i:1}/g;"
  i=$((i = i + 1))
done

# write cava config
config_file="/tmp/polybar_cava_config"
echo "
[general]
bars = 18
mode = scientific
framerate = 60
autosens = 1  

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7

[smoothing]
integral = 0.7
monstercat = 1
waves = 1
gravity = 1
ignore = 0
" >$config_file

# read stdout from cava
cava -p $config_file | while read -r line; do
  echo $line | sed $dict
done
