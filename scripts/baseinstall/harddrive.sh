#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
######## This is a ONE TIME MENU
export NCURSES_NO_UTF8_ACS=1

### PUT IF SETUP ALREADY, EXIT

HEIGHT=10
WIDTH=55
CHOICE_HEIGHT=4
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Make A Choice - Visit Again In Settings!"

OPTIONS=(A "YES: Second HD Will Be Used! It's READY!"
         B "YES: Second HD Will Be Used! It's NOT READY"
         C "NO:  No SECOND HD!"
         D "MINI FAQ: Why this Question?")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      bash /opt/plexguide/scripts/baseinstall/path.sh
      exit
      ;;
    B)
      dialog --title "HD Selection" --msgbox "\nYou Selected: Yes, but not ready!\n\nWhen your ready, visit SETTINGS for setup ANYTIME!" 0 0
      echo "nr" > /var/plexguide/server.hd
      echo "/mnt" > /var/plexguide/server.hd.path
      exit
      ;;
    C)
      dialog --title "HD Selection" --msgbox "\nYou Selected: NO 2ND Harddrive for SETUP!\n\nNeed to Make Changes? Visit SETTINGS and change ANYTIME!" 0 0
      echo "no" > /var/plexguide/server.hd
      echo "/mnt" > /var/plexguide/server.hd.path
      exit
      ;;
    D)
      dialog --title "Quick Story" --msgbox "\nThe purpose of this is to seperate your downloaded/downloading content to occur on another HD.\n\nRunning PLEX and having everything download to one drive can result in slow performace! If you have a second HD, you can use this to help improve your performance (and great for those using SMALL SSD's as their primary drives)." 0 0
      bash /opt/plexguide/scripts/baseinstall/harddrive.sh
      exit
    ;;
esac

file="/opt/appdata/$app"
if [ -e "$file" ]
    then

        if dialog --stdout --title "Backup User Confirmation" \
            --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
            --yesno "\nDo you want to BACKOUT & EXIT from making the Backup -- $app -- ?" 0 0; then
            dialog --title "PG Backup Status" --msgbox "\nExiting! User selected to NOT Install!" 0 0
            sudo bash /opt/plexguide/menus/backup-restore/backup.sh
            exit 0
        else
            clear
        fi
    else
        dialog --title "PG Backup Status" --msgbox "\nExiting! You have no LOCAL data -- $app -- to backup to GDrive!" 0 0
        sudo bash /opt/plexguide/menus/backup-restore/backup.sh
        exit 0
fi


exit
