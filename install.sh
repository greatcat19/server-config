#!/bin/bash
if [ ! -d "$HOME/.config" ]; then
    mkdir $HOME/.config
fi

pushd $HOME/.config

git clone https://github.com/greatcat19/greatcat19.git

