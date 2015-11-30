#!/bin/bash

case "$1" in
server)
	scp -P 2223 ../*.rb ../config.ru cqls@sagag6.upmf-grenoble.fr:dyndoc-ws/
	;;
tools)
	cp -r ../tools $HOME/Dropbox/dyndoc-ws-proj/
	;;
*)
	echo "./deploy-dyndoc-ws-proj server|tools"
esac