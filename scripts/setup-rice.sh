#!/bin/bash

if [ "$EUID" -eq 0 ]
then
	echo -e "Do not run the script as root!\nEnter user password only when prompted!\nSetup aborted!"
	exit
fi


# Adding custom fonts(System-Wide)
sudo mkdir -pv /usr/local/share/fonts/
sudo cp -r ../fonts/* /usr/local/share/fonts/

# Making the scripts globally accessible(using hard links)
sudo ln ./keyboard-backlight.sh /usr/bin/keyboard-backlight
sudo ln ./fortuneteller.sh /usr/bin/
sudo ln ./configman.sh /usr/bin/configman

# Adding 3rd parties to APT
sudo mkdir -pv /etc/apt/keyrings
### Adding Charm Bracelet
##curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
##echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list

sudo apt update

# Running the script that downloads the apps
sudo ./installapps.sh

# Adding the custom configs
configman --update-all

# Disabling gdm from autostarting
##sudo systemctl set-default multi-user.target


# Creating the workspace directories
mkdir -pv ~/workspace/main/
mkdir ~/workspace/side/

# Moving the debianrice directory to side projects directory
mv ../../debianrice ~/workspace/side/

