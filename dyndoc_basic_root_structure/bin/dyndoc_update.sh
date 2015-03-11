## functions to update dyndoc (ruby and R)
dyn-R4rb-update() {
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

dyn-ruby-core-update() {
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

dyn-ruby-doc-update() {
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

dyn-rb4R-update() {
  prevdir=$(pwd)

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

dyn-ruby-update() {
  dyn-R4rb-update
  dyn-ruby-core-update
  dyn-ruby-doc-update
}

dyn-R-update() {
  dyn-rb4R-update
}

dyn-ruby-bin-update() {
  prevdir=$(pwd)
  cd $DYNDOC_HOME/bin
  if [ -d .tmp ]; then rm -fr .tmp; fi 
  mkdir .tmp
  cd .tmp
  wget https://raw.githubusercontent.com/rcqls/dyndoc-ruby-install/master/dyndoc_basic_root_structure/bin/dyndoc-compile.rb
  wget https://raw.githubusercontent.com/rcqls/dyndoc-ruby-install/master/dyndoc_basic_root_structure/bin/dyndoc-package.rb
  wget https://raw.githubusercontent.com/rcqls/dyndoc-ruby-install/master/dyndoc_basic_root_structure/bin/dyndoc-server-simple.rb
  wget https://raw.githubusercontent.com/rcqls/dyndoc-ruby-install/master/dyndoc_basic_root_structure/bin/dyndoc_update.sh
  wget https://raw.githubusercontent.com/rcqls/dyndoc-ruby-install/master/dyndoc_basic_root_structure/bin/atom_update.sh
  cd ..
  mv .tmp/* .
  rm -fr .tmp
  if [[ $MSYSTEM =~ ^MSYS ]]; then
    cd msys2
    mkdir .tmp
    cd .tmp
    wget https://raw.githubusercontent.com/rcqls/dyndoc-ruby-install/master/dyndoc_basic_root_structure/bin/msys2/dyndoc.sh
    wget https://raw.githubusercontent.com/rcqls/dyndoc-ruby-install/master/dyndoc_basic_root_structure/bin/msys2/file_tools.rb
    cd ..
    mv .tmp/* .
    rm -fr .tmp
  fi
  
  cd $prevdir
}