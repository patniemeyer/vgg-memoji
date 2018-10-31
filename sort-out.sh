#!/bin/sh

# Sort the files in the folder 'out' by their filenames numerically and rename them by prefixing their ranking number.
# This just makes it easer to review them in the Finder on Mac OS.

count=0
for file in `ls out/ | sort -rn`
do
  mv out/$file out/"${count}-$file"
  count=`expr $count \+ 1`
done
