#!/bin/bash
echo -e "\033[1;31mRemoving learnTerminalTN...\033[0m"

# Safety confirmation
read -p "Are you sure? (y/n): " -n 1 -r
echo
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 1

sudo rm -vf /usr/local/bin/learnTerminalTN
sudo rm -vrf /usr/local/lib/learnTerminalTN
echo -e "\033[1;32mUninstall complete!\033[0m"