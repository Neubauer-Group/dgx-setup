import numpy as np
from matplotlib.figure import Figure

if __name__ == "__main__":
    x = np.linspace(0, 10, 1000)
    y = np.sin(x)

    fig = Figure()
    ax = fig.subplots()
    ax.plot(x, y)

    ax.set_xlabel(r"$x$")
    ax.set_ylabel(r"$\sin x$")

    fig.savefig("mpl_example.png")
