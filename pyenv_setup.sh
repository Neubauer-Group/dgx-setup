#!/bin/bash

cd "${HOME}"

# Install pyenv and pyenv-virtualenv
export PYENV_RELEASE_VERSION=2.0.3
git clone https://github.com/pyenv/pyenv.git \
	--branch "v${PYENV_RELEASE_VERSION}" \
	~/.pyenv
pushd ~/.pyenv
src/configure
make -C src
popd

# Setup .bash_profile
# Place the following comment '# pyenv setup' in your .bash_profile to set the placement
sed -i '/^# pyenv setup*/a export PYENV_ROOT="${HOME}/.pyenv"' ~/.bash_profile
sed -i '/^export PYENV_ROOT.*/a export PATH="${PYENV_ROOT}/bin:${PATH}"' ~/.bash_profile
sed -i '/^export PATH=\"${PYENV.*/a \\n# Place pyenv shims on path\nif [[ ":${PATH}:" != *":$(pyenv root)/shims:"* ]]; then\n  eval "$(pyenv init --path)"\nfi' ~/.bash_profile

# Setup .bashrc_user
printf '\neval "$(pyenv init -)"\n' >> ~/.bashrc_user
. ~/.bash_profile

# Setup pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

printf '\n# Place pyenv-virtualenv shims on path\nif [[ ":${PATH}:" != *":$(pyenv root)/plugins/pyenv-virtualenv/shims:"* ]]; then\n  eval "$(pyenv virtualenv-init -)"\nfi\n' >> ~/.bash_profile
printf '\n# Place pyenv shims on path\nif [[ ":${PATH}:" != *":$(pyenv root)/shims:"* ]]; then\n  eval "$(pyenv init --path)"\nfi\n' >> ~/.bashrc_user
printf '# Place pyenv-virtualenv shims on path\nif [[ ":${PATH}:" != *":$(pyenv root)/plugins/pyenv-virtualenv/shims:"* ]]; then\n  eval "$(pyenv virtualenv-init -)"\nfi\n' >> ~/.bashrc_user

unset PYENV_RELEASE_VERSION
