#!/bin/bash

export DEFAULT_HOME="/home/${USER}"
export RAID_HOME="/raid/projects/${USER}"

# Make restore files of system defaults
cp "${DEFAULT_HOME}/.bash_profile" "${DEFAULT_HOME}/.bash_profile.bak"
cp "${DEFAULT_HOME}/.bashrc" "${DEFAULT_HOME}/.bashrc.bak"
cp "${DEFAULT_HOME}/.bash_logout" "${DEFAULT_HOME}/.bash_logout.bak"

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

# Ensure minimal required .bashrc_user
# * Ensure desired shebang
if [ ! "$(sed -n '/^#!/p;q' ${RAID_HOME}/.bashrc_user)" ]; then
    # If no shebang assume zero-sized (empty) file
    echo '#!/usr/bin/env bash' > "${RAID_HOME}/.bashrc_user"
	# Ensure the shebang '#!/usr/bin/env bash'
	elif [ ! "$(sed -n '/^#!\/usr\/bin\/env bash/p;q' ${RAID_HOME}/.bashrc_user)" ]; then
	    sed -i "1s/.*/#!\/usr\/bin\/env bash/" "${RAID_HOME}/.bashrc_user"
fi
# * Ensure exporting of HOME
if ! grep -q 'export HOME="/raid/projects/${USER}"' "${RAID_HOME}/.bashrc_user"; then
   printf '\nexport HOME="/raid/projects/${USER}"\n' >> "${RAID_HOME}/.bashrc_user"
fi
# * Inject `cd $HOME` after the sourcing of .bashrc (and so .bashrc_user)
sed -i "$(($(grep -n 'f ~/.bashrc ];' ${RAID_HOME}/.bash_profile | cut -f1 -d:) + 4))"' i # .bashrc_user sets $HOME to another location than default' "${RAID_HOME}/.bash_profile"
sed -i "$(($(grep -n 'f ~/.bashrc ];' ${RAID_HOME}/.bash_profile | cut -f1 -d:) + 5))"' i cd "${HOME}"\n' "${RAID_HOME}/.bash_profile"


# symlink .Xauthority from default home to home on /raid
ln --symbolic --force $(readlink -f "${DEFAULT_HOME}/.Xauthority") $(readlink -f "${RAID_HOME}/.Xauthority")

# symlink .ssh info from default home to home on /raid
ln --symbolic $(readlink -f "${DEFAULT_HOME}/.ssh") $(readlink -f "${RAID_HOME}")/.ssh

# Set RAID_HOME as new HOME in .bash_profile
sed -i '/^# .bash_profile*/a export HOME="/raid/projects/${USER}"' "${RAID_HOME}/.bash_profile"

# Source .bash_aliases and .bashrc_user from .bashrc
printf '\n# User specific aliases and functions\nif [ -f ~/.bash_aliases ]; then\n    . ~/.bash_aliases\nfi\n' >> "${RAID_HOME}/.bashrc"
printf "\n# Instead of directly editing the system's default .bashrc load a user version\nif [ -f ~/.bashrc_user ]; then\n    . ~/.bashrc_user\nfi\n" >> "${RAID_HOME}/.bashrc"

# Inject `# pyenv setup` before sourcing .bashrc (and so .bashrc_user) for use in pyenv_setup.sh
sed -i "$(($(grep -n 'f ~/.bashrc ];' ${RAID_HOME}/.bash_profile | cut -f1 -d:) - 1))"' i # pyenv setup\n' "${RAID_HOME}/.bash_profile"

unset DEFAULT_HOME
unset RAID_HOME
