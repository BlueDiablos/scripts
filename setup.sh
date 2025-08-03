#!/usr/bin/env bash

packageManager=''

if command -v apt-get &> /dev/null; then
   echo -n "Found apt"
   echo
   packageManager="apt"
elif command -v dnf &> /dev/null; then
   echo -n "Found dnf"
   echo
   packageManager="dnf"
elif command -v pacman &> /dev/null; then
   echo -n "Found pacman"
   echo
   packageManager="pacman"
else
   echo -n "No supported package manager found"
   echo
fi

echo -n "Updating system..."
sudo $packageManager update -y 
sudo $packageManager upgrade -y

echo -n "Installing git..."
sudo $packageManager install git -y

echo -n "Installing tmux..."
sudo $packageManager install tmux -y

echo -n "Installing neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /usr/bin/nvim -xzf nvim-linux-x86_64.tar.gz

echo -n "adding path to bashrc"
echo -n export PATH="$PATH:/opt/nvim-linux-x86_64/bin" >> $HOME/.bashrc

echo -n "Cleaning up installation files.."
sudo rm -r nvim-linux-x86_64.tar.gz

echo -n "Would you like to setup a bare repo for dotfile(s) management?"
read bareRepo

if [[ "bareRepo" == "y" ]]; then
   echo -n "Setting up bare repo for dotfiles..."
   git init --bare $HOME/.cfg
   alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
   config config --local status.showUntrackedFiles no

   echo -n "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc

else
   echo -n "Skipping bare repo setup..."
fi

echo -n "Would you like to generate rsa keys? y/n:"
read generateKeys

if [[ $generateKeys == "y" ]]; then
   echo -n "Generating ssh keys"
   ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1

   content=$(cat ~/.ssh/id_rsa.pub)
   if [-z "$content"]; then
      echo -n "Could not obtain value for id_rsa.pub"
   fi
fi

echo -n "Would you like to pull down your dotfiles? y/n:"
read pullDotFiles

if [[ "$pullDotFiles" == "y" ]]; then
   #todo fetch dotfiles from git
   git clone "https://gitea.houseblackledge.net/jblack/dotfiles.git:~/projects/dotfiles"
   #copy files to expected directories
   #cp -r nvim/ ~/.config/nvim
   #cp .ideavimrc ~/.ideavimrc
fi

echo "Setup finished"

