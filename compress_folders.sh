#!/bin/bash
for folder in */
do
#mx0 for no compression
#mx9 for ultra compression
  7z a -mx0 -mmt "${folder%/}.7z" "$folder"
done
