if [[ $MSYSTEM =~ ^MSYS ]]; then
	if [ "$WD" = "" ]; then
		# required in ~/dyndoc/bin/msys2/file_tools.rb and dyndoc
  		export WD="${USERPROFILE}\\dyndocMsys32\\usr\\bin\\"
	fi
	export DYNDOC_MSYS2_HOME="`ruby ~/dyndoc/bin/msys2/file_tools.rb home`"
	. $DYNDOC_MSYS2_HOME/dyndoc/bin/msys2/dyndoc.sh
else
	export DYNDOC_HOME=~/dyndoc
	export PATH="`ruby -e 'print Gem.user_dir'`/bin:$DYNDOC_HOME/bin:$PATH"
fi

. $DYNDOC_HOME/bin/dyndoc_update.sh
. $DYNDOC_HOME/bin/atom_update.sh
