#!/bin/bash

export DEFAULT_HOME="/home/${USER}"
export RAID_HOME="/raid/projects/${USER}"

mkdir -p "${RAID_HOME}"
cd "${RAID_HOME}"


cp "/home/${USER}/".bash* .
# symlink Bash files from home on /raid to old home
ln --symbolic --force $(readlink -f "${RAID_HOME}/.bash_profile") $(readlink -f "${DEFAULT_HOME}/.bash_profile")
ln --symbolic --force $(readlink -f "${RAID_HOME}/.bashrc") $(readlink -f "${DEFAULT_HOME}/.bashrc")
ln --symbolic --force $(readlink -f "${RAID_HOME}/.bash_logout") $(readlink -f "${DEFAULT_HOME}/.bash_logout")

if [ -f "${RAID_HOME}/.bashrc_user"]; then
  ln --symbolic --force $(readlink -f "${RAID_HOME}/.bashrc_user") $(readlink -f "${DEFAULT_HOME}/.bashrc_user")
fi
if [ -f "${RAID_HOME}/.bash_aliases"]; then
  ln --symbolic --force $(readlink -f "${RAID_HOME}/.bash_aliases") $(readlink -f "${DEFAULT_HOME}/.bash_aliases")
fi

# symlink .ssh info from default home to home on /raid
ln --symbolic $(readlink -f "${DEFAULT_HOME}/.ssh") $(readlink -f "${RAID_HOME}")/.ssh

# Set RAID_HOME as new HOME in .bash_profile
sed -i '/^# .bash_profile*/a export HOME="/raid/projects/${USER}"' "${RAID_HOME}/.bash_profile"

unset DEFAULT_HOME
unset RAID_HOME
