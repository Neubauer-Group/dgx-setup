#!/bin/bash

export DEFAULT_HOME="/home/${USER}"
export RAID_HOME="/raid/projects/${USER}"

mkdir -p "${RAID_HOME}"
cd "${RAID_HOME}"


cp "${DEFAULT_HOME}/".bash* .
# symlink Bash files from RAID_HOME to DEFAULT_HOME so still usable
ln --symbolic --force $(readlink -f "${RAID_HOME}/.bash_profile") $(readlink -f "${DEFAULT_HOME}/.bash_profile")
ln --symbolic --force $(readlink -f "${RAID_HOME}/.bashrc") $(readlink -f "${DEFAULT_HOME}/.bashrc")
ln --symbolic --force $(readlink -f "${RAID_HOME}/.bash_logout") $(readlink -f "${DEFAULT_HOME}/.bash_logout")

# Ensure .bash_aliases and .bashrc_user exist
touch "${RAID_HOME}/.bash_aliases"
ln --symbolic --force $(readlink -f "${RAID_HOME}/.bash_aliases") $(readlink -f "${DEFAULT_HOME}/.bash_aliases")
touch "${RAID_HOME}/.bashrc_user"
ln --symbolic --force $(readlink -f "${RAID_HOME}/.bashrc_user") $(readlink -f "${DEFAULT_HOME}/.bashrc_user")

# Also get .Xauthority
cp "${DEFAULT_HOME}/.Xauthority" .
ln --symbolic --force $(readlink -f "${RAID_HOME}/.Xauthority") $(readlink -f "${DEFAULT_HOME}/.Xauthority")

# symlink .ssh info from default home to home on /raid
ln --symbolic $(readlink -f "${DEFAULT_HOME}/.ssh") $(readlink -f "${RAID_HOME}")/.ssh

# Set RAID_HOME as new HOME in .bash_profile
sed -i '/^# .bash_profile*/a export HOME="/raid/projects/${USER}"' "${RAID_HOME}/.bash_profile"

# Source .bash_aliases and .bashrc_user from .bashrc
printf '\n# User specific aliases and functions\nif [ -f ~/.bash_aliases ]; then\n    . ~/.bash_aliases\nfi\n' >> "${RAID_HOME}/.bashrc"
printf "\n# Instead of directly editing the system's default .bashrc load a user version\nif [ -f ~/.bashrc_user ]; then\n    . ~/.bashrc_user\nfi\n" >> "${RAID_HOME}/.bashrc"

unset DEFAULT_HOME
unset RAID_HOME
