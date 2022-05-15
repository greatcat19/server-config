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
    sudo apt-get install -y zsh curl
  else
    brew install zsh curl
  fi
fi

if ! type "tmux" >/dev/null; then
  if [ "$IS_LINUX" = true ]; then
    sudo apt-get install -y tmux
  else
    brew install tmux
  fi
fi

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="amuse"/g' $HOME/.zshrc
sed -i 's/plugins=(git)/plugins=(git z zsh-autosuggestions)/g' $HOME/.zshrc

touch ~/.rc
echo "source ~/.rc" >> ~/.zshrc

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

git clone https://github.com/gpakosz/.tmux.git ~/.tmux
ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local

if ! type "nvim" > /dev/null; then
  if [ "$IS_LINUX" = true ]; then
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt-get update
    sudo apt-get install -y neovim
  else
    brew install neovim
  fi

  echo "alias vim='nvim'" >> $HOME/.rc
fi

if ! type "lvim" > /dev/null; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm install stable

  bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -y
  echo "alias lvim=$HOME/.local/bin/lvim" >> $HOME/.rc
fi

popd || exit 1
