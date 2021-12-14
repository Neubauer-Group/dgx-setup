# Setup procedure for HAL DGX

## Setup

1. After cloning, first migrate the `HOME` area from the `/home` area to under `/raid/projects`

```console
$ bash migrate_home.sh
```

**Note:** Before moving onto step 2 you will need to update your current environment.
You can do this either by logging out and then logging back in, or by sourcing your `/raid/projects/${USER}/.bash_profile`.

2. In your `/raid/projects/${USER}/.bash_profile` make sure that the following comment exists anywhere **above** the sourcing of `~/.bashrc` to set the start location for adding `pyenv` information to your `.bash_profile`

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

MLFlow [works best with Conda for managing environments](https://www.mlflow.org/docs/latest/projects.html#mlproject-file).
`pyenv` has the ability to install Conda distributions as well, so you can `pyenv install` whatever distribution you'd like (c.f. output of `pyenv install --list | grep conda`)

```console
$ pyenv install miniconda3-latest
```

To be able to use Conda for package management with or without `pyenv`, use the installed miniconda distribution to initialize Conda

```console
$ pyenv shell miniconda3-latest
$ conda init
$ conda config --set auto_activate_base false
```

and after a shell restart `conda` will now be found and useable.

You can treat the miniconda version that you've selected as you would any other `pyenv` version when creating a `pyenv` virtual environment.

```console
$ pyenv virtualenv miniconda3-latest mlflow-base
```

These Conda `pyenv` environments can be activated with either `pyenv activate` or `conda activate`, though it is recommended to **only** use `pyenv activate` as switching between `pyenv` environments with a `conda` environment activated will not update the Python runtime used.

Note that it is important to make sure the `auto_activate_base false` command is run &mdash; which results in the following being added to your `.condarc`

```console
$ grep auto_activate ~/.condarc
auto_activate_base: false
```

&mdash; to ensure that there won't be conflict between Conda environment Python runtimes and any other virtual environment that you have.
As `conda init` will still place `condabin` onto `PATH` you will not need to update [MLFlow's `MLFLOW_CONDA_HOME` shell variable](https://www.mlflow.org/docs/latest/projects.html#project-environments).
