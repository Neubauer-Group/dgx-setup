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

## Test

As a simple test that everything is working okay:

* Create a `pyenv` virtual environment

```console
pyenv virtualenv 3.8.11 base
```

* Activate the `base` virtual environment

```console
pyenv activate base
```

* Install some dependencies with `pip`

```console
python -m pip install --upgrade pip setuptools wheel
python -m pip install matplotlib
```

* Run a test example Python script

```console
python test/example.py
```

which should produce a plot named `mpl_example.png` in your current working directory.
