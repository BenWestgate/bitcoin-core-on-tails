#!/bin/bash
# Copyright (c) 2022 Ben Westgate
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
#################################################

# Implements the Application menu to access various features.
# Not all have been implemented as of 0.1.0-alpha

#################################################

export SUDO_ASKPASS=/usr/local/bin/askpass
device=$(lsblk --inverse --path --raw --output=NAME /dev/mapper/TailsData_unlocked | sed -n 3p)
USB=$(lsblk --inverse --path --raw --output=NAME /dev/mapper/TailsData_unlocked | tail -1)
response=$(zenity --question --window-icon=/usr/local/share/pixmaps/bails128.png --icon-name=media-removable --title='Bitcoin Core on Tails' --text='Clone - Create a fresh Bitcoin Core on Tails node.\n\nBackup - Duplicate your Bitcoin Core on Tails node.' --extra-button='Clone' --extra-button='Backup' --extra-button='Settings' --extra-button='Help' --switch --width=350)
[ "$response" == '' ] && exit
[ "$response" == 'Clone' ] && /usr/local/bin/init --clone
[ "$response" == 'Backup' ] && /usr/local/bin/init --backup
[ "$response" == 'Help' ] && help=$(zenity --window-icon=/usr/local/share/pixmaps/bails128.png --question --icon-name=help-faq-symbolic --title='Help Menu' --text='' --extra-button='Online Help' --extra-button='Donate' --extra-button='Report a Bug' --extra-button='About' --switch)
[ "$help" == 'Donate' ] && xdg-open bitcoin:BC1Q9KYUJH8NRRJ2VWW3MA8TERWCRM9WUA24MH7TU3?label=Donation%20to%20Bitcoin%20Core%20on%20Tails	#FIXME change address
[ "$help" == 'Report a Bug' ] && tor-browser https://github.com/BenWestgate/Bitcoin-Core-on-Tails/issues
[ "$help" == 'About' ] && zenity --info --window-icon=/usr/local/share/pixmaps/bails128.png --title='About Bitcoin Core on Tails' --icon-name=bails128 --text='Bitcoin Core on Tails version v0.1.0\n\nCopyright (C) 2022 Ben Westgate\n\nPlease contribute if you find Bitcoin Core on Tails useful. Visit <a href="https://twitter.com/BenWestgate_">https://twitter.com/BenWestgate_</a> for further information about the software.\nThe source code is available from <a href="https://github.com/BenWestgate/Bitcoin-Core-on-Tails">https://github.com/BenWestgate/Bitcoin-Core-on-Tails</a>.\n\nThis is experimental software.\nDistributed under the MIT software license, see the accompanying file COPYING or <a href="https://opensource.org/licenses/MIT">https://opensource.org/licenses/MIT</a>' --width=650
[ "$response" == 'Settings' ] && setting=$(zenity --window-icon=/usr/local/share/pixmaps/bails128.png --question --icon-name=org.gnome.Settings --title=Settings --text='Coming soon\n\nConfigure Bitcoin Core on Tails' --extra-button='Update Bitcoin Core' --extra-button='Passphrase' --extra-button='Sync Faster' --extra-button='Erase Device' --switch --width=300)
[ "$setting" == 'Update Bitcoin Core' ] && /usr/local/bin/init --download
[ "$setting" == 'Passphrase' ] && pass_mgmt=$(zenity --window-icon=/usr/local/share/pixmaps/bails128.png --question --icon-name=dialog-password --title='Passphrase Settings' --text='Coming soon\n\n<b>WARNING:</b> <span foreground="red">The only secure way to change or remove a compromised or weak passphrase is to erase the device AND use physical destruction. The old passwords may still be around, potentially for a very long time and can be used to access your bitcoin data with forensic tools.</span>' --extra-button='Add passphrase' --extra-button='Change passphrase' --extra-button='Remove passphrase' --extra-button='Remove forgotten' --switch --width=500)
[ "$setting" == 'Sync Faster' ] && zenity --window-icon=/usr/local/share/pixmaps/bails128.png --title='Sync Faster' --list --text='Coming soon - placeholder.' --column='' --column='Method' --checklist FALSE 'Disable Tor (Increases download speed)' FALSE 'Aggressive pruning (Use more RAM on small storage)' FALSE 'Enable Swap (Frees up RAM)' FALSE 'RAM Sync (Fastest but unsafe shutdown loses progress)' --width=433 --height=210
[ "$sync" == 'Disable Tor (Increases download bandwidth)' ] && sudo --askpass /usr/local/lib/do_not_ever_run_me
# TODO verify that this actually does something, and modify this file to have the box "checked" TRUE if it suceeds, and require a restart for turning it off. Also turn proxy off and restart core w/o wallets.
[ "$sync" == 'RAM Sync (Fastest but unsafe shutdown loses progress)' ] && { mnt_pnt=$(mktemp --directory); mkdir $mnt_pnt/{upper,work}; sudo --askpass mount -t tmpfs -o size=6G $mnt_pnt; sudo mount -t overlay overlay -o lowerdir=$HOME/.bitcoin/chainstate,upperdir=$mnt_pnt/upper,workdir=$mnt_pnt/work $HOME/.bitcoin/chainstate; bitcoin-qt --nodebuglog; sudo umount $HOME/.bitcoin/chainstate; rsync -a --del --verbose --progress $mnt_pnt $HOME/.bitcoin/chainstate; }
[ "$setting" == 'Erase Device' ] && zenity --window-icon=/usr/local/share/pixmaps/bails128.png --title='Confirm before erasing device' --icon-name=dialog-warning --question --ok-label='Delete' --cancel-label='Cancel' --text="<b><big>WARNING\!  Persistent volume deletion</big>\n\n\nYour persistent data will be deleted</b>\nAll data on the device will be lost.\n\n\nThe persistent volume $device ($(lsblk --output=SIZE --nodeps --noheading --raw $device)iB), on the <b>$(lsblk --inverse --noheadings --output=VENDOR,MODEL $device | tr -s ' ' | head -1)</b> device, will be deleted and wiped.\n\n<b>Are you sure you want to delete this device?</b>" --width=350 && sudo --askpass bash -c "cryptsetup erase --verbose $device ; shred --verbose $device; shred --verbose $USB; shutdown"
gtk-launch bails.desktop
