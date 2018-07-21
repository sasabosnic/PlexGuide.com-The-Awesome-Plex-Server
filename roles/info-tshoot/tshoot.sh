#!/bin/bash
export NCURSES_NO_UTF8_ACS=1
HEIGHT=13
WIDTH=56
CHOICE_HEIGHT=7
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Assistance Menu"
MENU="Make a Selection Choice:"

OPTIONS=(A "Run PreInstaller - Basic Run Through"
         B "Run PreInstaller - Force Full Everything Reinstall"
         C "Uninstall Docker, Containers & Run PreInstaller"
         D "Uninstall PlexGuide"
         E "Change Server Setup"
         F "Ansible Bug Test"
         Z "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
# ansible-playbook /opt/plexguide/pg.yml --tags var
clear
case $CHOICE in
        A)
            echo "0" > /var/plexguide/pg.preinstall.stored
            dialog --title "Action Confirmed" --msgbox "\nPLEASE EXIT and Restart PLEXGUIDE!" 0 0
            exit 0 ;;
        B)
            echo "0" > /var/plexguide/pg.preinstall.stored
            echo "0" > /var/plexguide/pg.ansible
            echo "0" > /var/plexguide/pg.rclone
            echo "0" > /var/plexguide/pg.python
            echo "0" > /var/plexguide/pg.docstart
            echo "0" > /var/plexguide/pg.watchtower
            echo "0" > /var/plexguide/pg.label
            echo "0" > /var/plexguide/pg.alias
            echo "0" > /var/plexguide/pg.dep
            dialog --title "Action Confirmed" --msgbox "\nPLEASE EXIT and Restart PLEXGUIDE!" 0 0
            exit 0 ;;
        C)
            rm -r /etc/docker
            apt-get purge docker-ce
            rm -rf /var/lib/docker
            rm -r /var/plexguide/dep*
            dialog --title "Note" --msgbox "\nPLEASE EXIT and Restart PLEXGUIDE!" 0 0
            exit 0 ;;
        D)
            rm -r /var/plexguide/dep* 1>/dev/null 2>&1
            bash /opt/plexguide/roles/uninstall/main.sh
            ;;
        E)
            rm -r /var/plexguide/server.settings.set 1>/dev/null 2>&1
            echo "0" > /var/plexguide/pg.preinstall.stored
            dialog --title "Action Confirmed" --msgbox "\nPLEASE EXIT and Restart PLEXGUIDE!\n\nYou will be asked again after the Pre-Install!" 0 0
            ;;
        F)
            ansible-playbook /opt/plexguide/pg.yml --tags test
            echo ""
            echo "If no RED, Ansible is good; if RED, ansible is bugged!"
            echo ""
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        Z)
            clear
            exit 0 ;;
esac

### loops until exit
bash /opt/plexguide/menus/info/main.sh