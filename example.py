import matplotlib.pyplot as plt
import numpy as np

if __name__ == "__main__":
    x = np.linspace(0, 10, 1000)
    y = np.sin(x)

    fig, ax = plt.subplots()
    ax.plot(x, y)

    ax.set_xlabel(r"$x$")
    ax.set_ylabel(r"$\sin x$")

    fig.savefig("mpl_example.png")
