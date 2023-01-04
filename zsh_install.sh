#!/bin/bash

OH_MY_ZSH_SH=https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
PL10K_GIT=https://github.com/romkatv/powerlevel10k.git
INSTALL_FONTS=true

set -e
# set -x

# get sudo prompt immediately
sudo -v

# If the .oh-my-zsh file exists, delete the current installation and continue
if [ -e "${HOME}/.oh-my-zsh" ]; then
	while true; do
	    read -p "Oh my zsh appears to be installed. Delete installation and continue? " yn
	    case $yn in
	        [Yy]* ) break;;
	        [Nn]* ) exit;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
	rm -rf ${HOME}/.oh-my-zsh
	rm ${HOME}/.zshrc
fi

# Install zsh and set it as default
sudo apt install -y zsh
chsh -s $(which zsh)

# Run unattended installation for oh-my-zsh
sh -c "$(curl -fsSL $OH_MY_ZSH_SH)" "" --unattended

# Install powerlevel10k and change it in the .zshrc
git clone $PL10K_GIT ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i -E "s/THEME=\".+\"/THEME=\"powerlevel10k\/powerlevel10k\"/g" ~/.zshrc

sleep 1

# Get autosuggestions and apply ctrl space as the suggest accept
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i -E "s/plugins=\(.+\)/plugins=\(git zsh-autosuggestions\)/g" ${HOME}/.zshrc

echo "bindkey '^ ' autosuggest-accept" >> ${HOME}/.zshrc

# install fonts if wanted
if [ "$INSTALL_FONTS" == "true" ]; then
	mkdir -p ${HOME}/.local/share/fonts
	cd ${HOME}/.local/share/fonts

	sudo wget -N https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
	sleep 1
	sudo wget -N https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
	sleep 1
	sudo wget -N https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
	sleep 1
	sudo wget -N https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
	echo "Giving some time to pick up on the fonts..."
	sleep 5
	fc-cache -f -v
	echo "Downloaded fonts and updated cache"

fi

echo "Installation completed. Set terminal font if applicable and start zsh."


