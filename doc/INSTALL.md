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

## dyndoc-ruby installation

You can manually install the following ruby and R tools:

* ruby gems: R4rb, dyndoc-ruby-core and dyndoc-ruby-doc
* R package: rb4R

All these both steps are more easily done as follows:

* Open a terminal (msys2_shell.bat for Windows users, not the Mingw one) and then:
```{bash}
git clone git://github.com/rcqls/dyndoc-ruby-install.git
cd dyndoc-ruby-install/bin
./install_dyndoc.sh
```

## dyndoc-atom-viewer installation (very experimental)

Install first [atom](https://atom.io) and then open a terminal (Mingw for Windows users, not the  Msys2 one):
```{bash}
dyn-atom-update
```

## update dyndoc tools

* Update script: open a terminal and execute
```{bash}
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rcqls/dyndoc-ruby-install/master/bin/update_dyndoc.sh)"
```
* Then
```{bash}
# to update ~/dyndoc/bin directory
dyn-ruby-bin-update
# to update ruby dyndoc tools
dyn-ruby-update
# to update R dyndoc tools
dyn-R-update
# Windows user only: to update atom tools
dyn-atom-update 
```

## FAQ

* In msys2, sometimes you need to launch a "/c/msys(32|64)/autorebase.bat" when child links fail.
* Add R in the PATH (in .bash_profile or in the environment windows variable PATH)
* update_dyndoc.sh added to update dyndoc
* To install Ttm from source: compile it and when dyndoc is ready copy ttm binary in ~/dyndoc/bin
