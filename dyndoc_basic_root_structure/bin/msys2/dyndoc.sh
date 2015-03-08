## added automatically when installing dyndoc ruby
export DYNDOC_HOME="/home/${USERNAME}/dyndoc"
export PATH="`ruby -e 'print Gem.user_dir'`/bin:$DYNDOC_HOME/bin:$PATH"
export R_LIBS_USER=${DYNDOC_HOME}/install/R/library

export DYNDOC_MSYS2_ROOT="`ruby ~/dyndoc/bin/msys2/file_tools.rb global`"
export DYNDOC_ATOM_PATH="`ruby ~/dyndoc/bin/msys2/file_tools.rb atom`"
if [ "$DYNDOC_ATOM_PATH" != "" ]; then
  export PATH="$DYNDOC_ATOM_PATH:$DYNDOC_ATOM_PATH/resources/app/apm/bin:$PATH"
fi

#DYNDOC_R_PATH="$(ruby ~/dyndoc/bin/msys2/file_tools.rb global $USERPROFILE)/R-Portable/App/R-Portable/bin/i386"
#if [ "$DYNDOC_R_PATH" != "" ]; then
#  export PATH="$DYNDOC_R_PATH:$PATH"
#fi

# Check R and pdflatex in Msys2 PATH
if [ "$(which R)" = "" ]; then
	echo "R is not installed or in the PATH!"
 	echo "Add it in the environment variable %PATH%"
  echo "Go to: Control Panel -> System -> Advanced system Settings -> Environment Variables"
fi

if [ "$(which pdflatex)" = "" ]; then
	echo "pdflatex is not installed or in the PATH!"
  echo "Add it in the environment variable %PATH%"
  echo "Go to: Control Panel -> System -> Advanced system Settings -> Environment Variables"
fi
