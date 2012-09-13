#!/bin/sh

part_file=$1
conf_file=$2

f2="$(<$part_file)"
awk -vf2="$f2" '/## Custom changes ##/{print f2;print;next}1' $conf_file > /tmp/full.conf.bk
mv /tmp/full.conf.bk $conf_file