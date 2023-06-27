#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "You must BE a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

# Get the username and working directory
username=$(id -u -n 1000)
builddir=$(pwd)

# Changing repo to contrib non-free and updating currently installed programs
apt update
apt upgrade -y

# Installing some programs
apt install --no-install-recommends ntfs-3g dosfstools e2fsprogs exfatprogs mtools pcmanfm man fonts-powerline x11-utils pulseaudio pavucontrol openbox xfce4 lightdm slick-greeter xfce4-terminal wget python3-pip lxpolkit micro -y

# Enable Firewall (while and if statements are used just for the sake of it as I was learning bash scripting)
flag=true
echo "It's good to have a firewall installed."
while [ $flag == true ] ; do
	echo "Do you want to install the Uncomplicated Firewal (UFW)?"
	echo -n "[y]yes [n]no [default]yes : "
	read -r fw
	if [ "$fw" = "" ] || [ "$fw" == 'y' ];
	then
		apt install ufw -y
		echo "Activating firewall..."
		ufw enable
		flag=false
	elif [ "$fw" == 'n' ]
	then
		flag=false
	else
		echo "You have chosen invalid option. Choose either y or n."
		echo ""
	fi
done

# Change the current working directory
cd "$builddir" || exit

# Creating necessary directories
mkdir -p /etc/lightdm/
mkdir -p /home/"$username"/.config/screencapture/
mkdir -p /home/"$username"/Screenshots/

# Copy config files
cp xfopen-setup-guide.sh /home/"$username"/ # kind-of a user manual for my xfce-openbox setup
chmod +x /home/"$username"/xfopen-setup-guide.sh
cp lightdm.conf /etc/lightdm/ # lightdm login manager config file
cp screenshooter.sh /home/"$username"/.config/screencapture/ # a small bash script to take screenshot and store in Screenshots folder
chmod +x /home/"$username"/.config/screencapture/screenshooter.sh
chmod +x /home/"$username"/.config/screencapture/screenshooter.sh
chown -R "$username":"$username" /home/"$username" # otherwise you need sudo privileges whenever you want to change some of these files

# Adding user to groups input and video so that mouse, keyboard and displaying works
usermod -a -G input "$username"
usermod -a -G video "$username"

# Done
echo "Installation is now completed.
Reboot your system for the changes to take place.
We need to make some  manual changes to fully complete xfopen installation.
For that, after reboot, in the login page, click on the circular icon next to your username.
Select Xfce.
Type in password and login.
After login, open a terminal and type ~/xfopen-setup-guide.sh.
Bye bye.. See you in the terminal..."
