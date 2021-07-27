# Setup procedure for HAL DGX

## Setup

1. After cloning, first migrate the `HOME` area from the `/home` area to under `/raid/projects`

```console
$ bash migrate_home.sh
```

2. In your `/raid/projects/$USER/.bash_profile` make sure that the following comment exists anywhere **above** the sourcing of `~/.bashrc` to set the start location for adding `pyenv` information to your `.bash_profile`

```bash
# pyenv setup
```

and then run

```console
$ bash pyenv_setup.sh
```

3. Source your `.bash_profile` to make sure everything is setup and then install CPython `v3.8.11` from source with optimizations using `pyenv`

```console
$ . ~/.bash_profile
$ bash build_python.sh
```
