#!/usr/bin/bash
[[ "root" == "$(whoami)" ]] && { echo This script should not be run as root but as thy self; exit 1; }

cd $(dirname $0)

[[ -f "./env" ]] && . ./env
echo "Copying files under $HOME"

for dir in $(find home -type d -printf "%P\n"); do 
	mkdir -p ${HOME}/$dir
done

for file in $(find home -type f -printf "%P\n"); do 
	cp $(pwd)/home/$file  $HOME/$file
	chmod --reference $(pwd)/home/$file $HOME/$file
done
