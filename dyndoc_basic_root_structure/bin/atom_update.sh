dyn-atom-update() {
    if [[ $MSYSTEM =~ ^MSYS ]]; then
  		echo "Open this script inside a MINGW console!"
      pause
      exit
  	fi
    proto="https"
    if [ "$1" != "" ]; then 
      proto = "$1"
    fi
    if ! [ -d $DYNDOC_HOME/install/share ]; then
  	 mkdir -p $DYNDOC_HOME/install/share
    fi
  	cd $DYNDOC_HOME/install/share
    if [ -d $DYNDOC_HOME/install/share/dyndoc-syntax ]; then
      cd $DYNDOC_HOME/install/share/dyndoc-syntax
      git pull
    else
  	   git clone ${proto}://github.com/rcqls/dyndoc-syntax.git
    fi
    if [ -d $DYNDOC_HOME/install/share/atom-dyndoc-viewer ]; then
      cd $DYNDOC_HOME/install/share/atom-dyndoc-viewer
      git pull
    else
  	   git clone ${proto}://github.com/rcqls/atom-dyndoc-viewer.git
    fi
  	apm link dyndoc-syntax/atom/language-dyndoc
  	apm link atom-dyndoc-viewer
  	cd atom-dyndoc-viewer
  	apm install;apm rebuild
  	apm install language-r
  	echo " -> done!"
}

dyn-atom-addons() {
  if [[ $MSYSTEM =~ ^MSYS ]]; then
    echo "Open this script inside a MINGW console!"
    pause
    exit
  fi
  mkdir -p $DYNDOC_HOME/install/share
  cd $DYNDOC_HOME/install/share
  if [ -d atom-addons ]; then
    cd atom-addons
    unzip pdf-view.zip
    apm link pdf-view
  fi
}
