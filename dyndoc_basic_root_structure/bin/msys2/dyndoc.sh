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

## functions to update dyndoc (ruby and R)
dyn-update-R4rb() {
  prevdir=$(pwd)

  cd $prevdir

  if [ -d $DYNDOC_HOME/install/ruby ]; then
  	echo "ruby update: R4rb gem"
  	cd $DYNDOC_HOME/install/ruby
  	cd R4rb;git pull;rake install
  else
  	echo "ruby update available only when $DYNDOC_HOME/install/ruby exists"
  fi

  cd ${prevdir}
}

dyn-update-core() {
  prevdir=$(pwd)

  cd $prevdir

  if [ -d $DYNDOC_HOME/install/ruby ]; then
  	echo "ruby update: dyndoc-ruby-core gem"
  	cd $DYNDOC_HOME/install/ruby
  	cd dyndoc-ruby-core;git pull;rake install
  else
  	echo "ruby update available only when $DYNDOC_HOME/install/ruby exists"
  fi

  cd ${prevdir}
}

dyn-update-doc() {
  prevdir=$(pwd)

  cd $prevdir

  if [ -d $DYNDOC_HOME/install/ruby ]; then
  	echo "ruby update: dyndoc-ruby-doc gem"
  	cd $DYNDOC_HOME/install/ruby
  	cd dyndoc-ruby-doc;git pull;rake install
  else
  	echo "ruby update available only when $DYNDOC_HOME/install/ruby exists"
  fi

  cd ${prevdir}
}

dyn-update-rb4R() {
  prevdir=$(pwd)

  cd $prevdir

  if [ -d $DYNDOC_HOME/install/R ]; then
  	echo "R update: rb4R R package"
  	cd $DYNDOC_HOME/install/R
  	cd rb4R;git pull;cd ..
  	PREFIX_R=""
  	if [ "$R_LIBS_USER" != ""  ]; then
  		PREFIX_R="-l $R_LIBS_USER"
  	fi
  	R CMD INSTALL $PREFIX_R rb4R
  else
  	echo "R update available only when $DYNDOC_HOME/install/R exists"
  fi

  cd ${prevdir}
}

dyn-update-ruby() {
  dyn-update-R4rb
  dyn-update-core
  dyn-update-doc
}

dyn-update-R() {
  dyn-update-rb4R
}

