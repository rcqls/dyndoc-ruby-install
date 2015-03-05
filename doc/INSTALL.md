# Dyndoc

## Basic requirements

### MacOSX
* ruby: xcode provides one and homebrew is based on ruby.
* [homebrew](http://brew.sh) (optional)
* [R](http://cran.r-project.org/bin/macosx/)
* [latex (MacTex)](http://www.tug.org/mactex/)
* [pandoc](https://github.com/jgm/pandoc/releases)
* [Ttm](http://hutchinson.belmont.ma.us/tth/mml) from source
* git:
if homebrew option
```{bash}
brew install git
```

### Windows
* [MSYS2](http://msys2.github.io)
* complete the msys2 installation with certificates, ruby, git, wget and unzip (copy-paste in msys2_shell the following 5 lines): 
```{bash}
pacman -S --noconfirm ca-certificates
pacman -S --noconfirm ruby
pacman -S --noconfirm git
pacman -S --noconfirm wget
pacman -S --noconfirm unzip
```
* [R](http://cran.r-project.org/bin/windows/base/)
* latex (with pdflatex in PATH) : [MikTex](http:/miktex.org)
* [pandoc](https://github.com/jgm/pandoc/releases)
* [Ttm](http://hutchinson.belmont.ma.us/tth/mml)

Note: other alternative could be [rubyinstaller](http://rubyinstaller.org) with [devkit](http://rubyinstaller.org/add-ons/devkit) (no more investigated in this project).

### Linux
There are many distributions but mainly all of them provide the following:

* ruby (>=2.0): ruby-dev (or similar) is usually required.
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
* [atom](https://atom.io) editor package: language-dyndoc (see dyndoc-syntax), atom-dyndoc-viewer

All these steps are more easily done as follows:

* Open a terminal (msys2_shell.bat for Windows users, not the Mingw one) and then:
```{bash}
git clone git://github.com/rcqls/dyndoc-ruby-install.git
cd dyndoc-ruby-install/bin
./install_dyndoc.sh
```
* Atom editor installation (Windows MSYS2):
```{bash}
./install_atom_win.sh
```
* Atom editor installation (Linux and MacOSX): install first [atom](https://atom.io) and then
```{bash}
./install_atom_dyndoc.sh
```
* Final step: add ~/dyndoc/bin to your PATH (in your ~/.bash_profile)


## FAQ

* In msys2, sometimes you need to launch a "/c/msys(32|64)/autorebase.bat" when child links fail.
* Add R in the PATH (in .bash_profile or in the environment windows variable PATH)
* update_dyndoc.sh added to update dyndoc
* To install Ttm from source: compile it and when dyndoc is ready copy ttm binary in ~/dyndoc/bin 
