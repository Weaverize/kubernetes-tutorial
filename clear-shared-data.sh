#!/bin/bash
set -e

datadir="volumes/shared-data"

echo "Deleting content in $datadir..."
ls "$datadir" |while read subdir
do
	path="$datadir/$subdir"
	echo "- $path"
	sudo rm -rf "$path"
done

echo "Done"