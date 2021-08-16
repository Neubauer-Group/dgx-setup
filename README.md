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
$ pyenv virtualenv 3.8.11 base
```

* Activate the `base` virtual environment

```console
$ pyenv activate base
```

* Install some dependencies with `pip`

```console
(base) $ python -m pip install --upgrade pip setuptools wheel
(base) $ python -m pip install matplotlib
```

* Run a test example Python script

```console
(base) $ python test/example.py
```

which should produce a plot named `mpl_example.png` in your current working directory.

## Optional Conda Install for MLFlow
MLFlow works best with conda. To install it:

* Download a copy of the miniconda install script
```console
$ wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.10.3-Linux-x86_64.sh
```

* Execute the install script
```console
$ bash Miniconda3-py38_4.10.3-Linux-x86_64.sh
```

* Accept the license terms
* Accept the defaults and allow it to run `conda init`
