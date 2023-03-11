#!/usr/bin/env bash

# Install Erlang, Elixir and Node.js from ASDF on macOS

set -e

# Environment vars
export LANG="${LANG:-en_US.UTF-8}"

# Optional ASDF_RELEASE

echo "==> Initialize package manager and install basic utilities"

# http://erlang.org/doc/installation_guide/INSTALL.html#required-utilities
# https://github.com/asdf-vm/asdf-erlang

echo "==> Install ASDF plugin dependencies"

echo "===> Installing common ASDF plugin deps"
brew install coreutils automake libyaml readline libtool

echo "===> Installing ASDF Erlang plugin deps"
brew install autoconf # build tools
brew install openssl # OpenSSL - v3 is supported in Erlang v25+
brew install wxwidgets # observer and debugger
brew install libxslt fop # documentation and elixir reference builds
brew install unixodbc 

echo "===> Installing ASDF Node.js plugin deps"
brew install gpg

echo "==> Install ASDF and plugins"

# TODO - this is trickier on M1 because you might want to install an x86 asdf alongside an arm64 asdf

# Once asdf is installed:

# 1. Erlang, following: https://github.com/asdf-vm/asdf-erlang#osx
asdf plugin-add erlang || true
asdf plugin-add elixir || true
asdf plugin-add nodejs || true

echo "===> Installing build deps with ASDF"
# see https://github.com/asdf-vm/asdf-erlang/issues/191#issuecomment-1207080354
sudo ln -sfn $(realpath $(brew --prefix unixodbc)) /usr/local/odbc                                                                                                                  
sudo chown -R $(whoami) /usr/local/odbc
export KERL_CONFIGURE_OPTIONS="--without-javac --with-odbc=$(realpath $(brew --prefix unixodbc))"
export CC="/usr/bin/gcc -I$(brew --prefix unixodbc)/include"
export LDFLAGS="-L$(brew --prefix unixodbc)/lib"

asdf install