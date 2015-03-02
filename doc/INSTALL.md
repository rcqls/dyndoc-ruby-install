# Dyndoc

## Basic requirements

### MacOSX
1. ruby: xcode provides one and homebrew is based on ruby.
2. [homebrew](http://brew.sh) (optional)
* [R](http://cran.r-project.org/bin/macosx/)
* [latex (MacTex)](http://www.tug.org/mactex/)
* [pandoc](https://github.com/jgm/pandoc/releases)
* [Ttm](http://hutchinson.belmont.ma.us/tth/mml) from source
* git: brew install git (if homebrew option)

### Windows
1. [MSYS2](http://msys2.github.io)
* ruby: pacman -S ruby (msys version)
* [R](http://cran.r-project.org/bin/windows/base/)
* latex (with pdflatex in PATH) : [MikTex](http:/miktex.org)
* [pandoc](https://github.com/jgm/pandoc/releases)
* [Ttm](http://hutchinson.belmont.ma.us/tth/mml)
* git: pacman -S git

Note: other alternative could be [rubyinstaller](http://rubyinstaller.org) with [devkit](http://rubyinstaller.org/add-ons/devkit) (no more investigated in this project).

### Linux
There are many distributions but mainly all of them provide the following:

1. ruby (>=2.0): ruby-dev (or similar) is usually required.
For ubuntu, if the default ruby version is lower than 2.0, install ruby2 and ruby-switch (using update-alternatives).
* R (>=3.0): r-base-dev (or similar) is usually required.
* latex (texlive for example)
* pandoc
* [Ttm](http://hutchinson.belmont.ma.us/tth/mml) from source
* git

## Installation steps

The dyndoc-ruby installation is broken into 3 parts main parts:

1. ruby gems: R4rb, dyndoc-ruby-core and dyndoc-ruby-doc
* R package: rb4R
* [atom](https://github.com/atom/atom/releases) editor package: language-dyndoc (see dyndoc-syntax), atom-dyndoc-viewer

All these steps are more easily done as follows:

1. Open a terminal (msys2_shell.bat for Windows users, not the Mingw one)
* cd [temporary directory newly created]
* git clone https://github.com/rcqls/dyndoc-ruby-install.git
* cd dyndoc-ruby-install
* ./bin/install_dyndoc.sh
  * Windows system (MSYS2): ./bin/install_atom_win.sh
  * Other system: ./bin/install_atom_dyndoc.sh
* Final step: copy or link
  * add ~/dyndoc/bin to your PATH (in your ~/.bash_profile)


## FAQ

1. In msys2, sometimes you need to launch a "/c/msys2/autorebase.bat" when child links fail.
* Add R in the PATH (in .bash_profile or in the environment windows variable PATH) 
* R_LIBS_USER can be added in your .bash_profile to install locally rb4R R package
* update_dyndoc.sh added to update dyndoc
