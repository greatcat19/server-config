#!/bin/bash
if [ ! -d "$HOME/.config" ]; then
  mkdir $HOME/.config
fi

pushd $HOME/.config || exit

if [ "$(uname)" == "Darwin" ]; then
  IS_LINUX=false
# elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
else
  IS_LINUX=true
fi

if ! type "brew" >/dev/null; then
  if ! $IS_LINUX; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

git clone https://github.com/greatcat19/server-config.git

# if zsh does not exist install it
if ! type "zsh" >/dev/null; then
  if [ "$IS_LINUX" = true ]; then
    sudo apt-get install zsh curl
  else
    brew install zsh curl
  fi
fi

if ! type "tmux" >/dev/null; then
  if [ "$IS_LINUX" = true ]; then
    sudo apt-get install tmux
  else
    brew install tmux
  fi
fi

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="amuse"/g' $HOME/.zshrc
sed -i 's/plugins=(git)/plugins=(git z zsh-autosuggestions)/g' $HOME/.zshrc

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

git clone https://github.com/gpakosz/.tmux.git ~/.tmux
ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
cp .tmux/.tmux.conf.local ~
