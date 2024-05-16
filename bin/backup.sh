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

# bails-backup: Back up Tails' encrypted persistent storage
# into the backup storage area.

set -eu
set -o pipefail

export TEXTDOMAIN='tails'

# Tails' directories for source and destination
SOURCE='/live/persistence/TailsData_unlocked/'
DEST='/media/amnesia/TailsData/'

# size of source Tails device
SOURCE_SIZE=$(df --output=size $SOURCE | tail -1)

backup_luks_device() {
    if ! /usr/libexec/bilibop/test /dev/disk/by-partlabel/TailsData >/dev/null; then
        readlink -f "/dev/disk/by-partlabel/TailsData"
    fi
}

# Check for root.
if [[ $(id -u) = "0" ]]; then
  echo "
YOU SHOULD NOT RUN THIS SCRIPT AS ROOT!
YOU WILL BE PROMPTED FOR THE ADMIN PASS WHEN NEEDED.
"
  read -p "PRESS ENTER TO EXIT SCRIPT, AND RUN AGAIN AS amnesia. "
  exit 0
fi

    # Ask to retry if only the backup Tails USB stick is missing
    if [ ! -b "$(backup_luks_device)" ] && [ -d "$SOURCE" ]; then
        while [ ! -b "$(backup_luks_device)" ] || [ ! -b ]; do
            if ! zenity --question --ellipsize --title "$title" --text "$msg" --ok-label "$(gettext -s 'Retry')" --cancel-label "$(gettext -s 'Cancel')"; then
                exit 1
            fi
        done
    else
        exit 1
    fi

#title="$(gettext -s 'Create or Update your backup Tails')"
#if [ ! -d "$SOURCE" ] || [ ! -b "$(backup_luks_device)" ]; then
#    msg="$(gettext -s 'This utility creates or updates your backup Tails USB stick.\n\nTo create a backup Tails USB stick, please plug a USB flash drive or SD card of at least 16 GB.\n\n<b>Impossible to create or update your backup Tails.</b>\n\nTo update your backup Tails, you need to:')"
#    if [ ! -d "$SOURCE" ]; then
#        msg="${msg}""$(gettext -s '\n\n• Unlock your Persistent Storage when starting Tails.')"
#    fi
#    if [ ! -b "$(backup_luks_device)" ]; then
#        msg="${msg}""$(gettext -s '\n\n• Plug in your backup Tails USB stick.')"
#    fi

#fi

test -d /live/persistence/TailsData_unlocked || {
	zenity --info --text='No Persistent Storage has been unlocked. Quitting.'; exit 1; }

until wget --timestamping --wait=$((++k)) --waitretry=60 --random-wait --retry-connrefused https://raw.githubusercontent.com/bitcoin/bitcoin/master/src/chainparams.cpp; do sleep $((++k * (RANDOM % 3 + 1) / 2)); done & get_size=$!
sudo --askpass mv /etc/sudoers.d/always-ask-password{,.bak} &>>log && sudo --askpass echo # removes prompting for every sudo password every command, asks second time if file renamed

while test -f $HOME/.bitcoin/bitcoind.pid; do
		kill $(<$HOME/.bitcoin/bitcoind.pid)
		pkill bitcoin*
		sleep 1
done & shutdown=$!
tmp_log=$(mktemp)

#possibilitites:

#No USB then Display tails-backup error w/ retry

#USB is blank then password, tails-installer, add_persist, tails-backup (without prompts)

#USB has Tails, then password, add_persist, tails-backup (without prompts), then tails-installer to update

#USB has persistent Tails, then tails-backup, then tails-installer

#

# install or upgrade Tails to backup USB stick

tails-installer --verbose &>$tmp_log & tails_install=$!

while ps -p $tails_install > /dev/null; do
	luks=$(grep 'DEBUG: Skipping LUKS-encrypted partition:')
	install=$(grep 'INFO: Partitioning device' $tmp_log)
	reinstall=$(grep 'INFO: Removing existing Tails system' $tmp_log)
	device=$(grep 'INFO: Resetting Master Boot Record of' $tmp_log | awk '{print $NF}')
	sleep 5
	[ "$install" ] && passphrase_education
	[ "$reinstall" ] && [ -b "$(backup_luks_device)" ] && /usr/local/bin/tails-backup
done
[ "$device" ] || exit 1		# quit if no device was flashed
dev_name="$(lsblk --path --nodeps --noheading --output=SIZE,VENDOR,MODEL,LABEL "$device")"	# Use this to remind user which device is safe to eject after backup or cloning.
if [ $(lsblk --raw $device | grep -c part) -eq 1 ]; then
	temp_pass=$(keepassxc-cli generate --exclude-similar --lower --numeric --length=24)
	add_part $device $temp_pass /media/amnesia/TailsData	# new persistent file system will be mounted at $mnt_pnt
	benchmark 10
	passphrase 0
	password_success
	new_pw=true
fi
/usr/local/bin/tails-backup


if [ "$install" ]; then
elif [ "$reinstall" ]; then
else
	zenity --notification --text='You must install or upgrade Tails on your backup USB stick.' 
	exit 1
fi
TARGET_SIZE=$(df --output=size /media/$USER/TailsData | tail -1)



if ((TARGET_SIZE < SOURCE_SIZE)); then
	ps -p $get_size >/dev/null && fg %$(jobs -l | grep $get_size | cut -f1 -d' ' | tr -c -d '[:digit:]')
	assumed_chain_state_size=$(grep --max-count=1 m_assumed_chain_state_size chainparams.cpp | sed 's/[^0-9]*//g')
	DIFFERENCE=$((SOURCE_SIZE-TARGET_SIZE))
	SOURCE_PRUNE=$((($(df --output=avail $HOME/.bitcoin | tail -1) + $(du --summarize $HOME/.bitcoin/blocks | cut -f1)) - 10485760 > 1953125 ? ($(df --output=avail $HOME/.bitcoin | tail -1) + $(du --summarize $HOME/.bitcoin/blocks | cut -f1))/1024 - (4+'$assumed_chain_state_size')*1024 : 1907))
	TARGET_PRUNE=$((SOURCE_PRUNE-DIFFERENCE > 1953125 ? (SOURCE_PRUNE-DIFFERENCE)/1024 : 1907))
	# mount tmpfs overlay to prune to fit target device
	tmpdir=$(mktemp --directory)
	mkdir $tmpdir/{upper,work}
	cd $HOME
	sudo mount --types overlay overlay -o lowerdir=.bitcoin,upperdir=$tmp_dir/upper,workdir=$tmp_dir/work .bitcoin || { zenity --warning --text=Mounting overlayFS failed. ; exit 1 ; }
	/usr/local/bin/bitcoin-qt -prune=$TARGET_PRUNE -startupnotify='pkill bitcoin-qt'
	sudo rsync -PaSHAXv --del /live/persistence/TailsData_unlocked/ /media/$USER/TailsData
	sudo umount overlay
	rm --recursive $tmpdir
fi
	
#if [ "$1" == '--clone' ]; then		TODO once cloud backups are in give option to set the encrypted wallet data in new clones.
#	# wallets folder will be encrypted
#	tar -cvzf --remove-files - wallets/ | gpg -c > wallets/wallets.tar.gz.gpg
#fi
sudo rsync -PaSHAXv --del /live/persistence/TailsData_unlocked/ /media/$USER/TailsData






# TODO required for clones to be useful 
#if [ "$1" == '--clone' ]; then add --first-run script .desktop to /media/$USER/TailsData/autostart

sudo mv /etc/sudoers.d/always-ask-password{.bak,} &>>log & # restores default sudo every command behavior TODO consider making this an exiting function
