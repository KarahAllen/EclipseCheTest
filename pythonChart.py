import matplotlib.pyplot as plt
import numpy as np

# Generate some data
x = np.linspace(0, 20, 100)
y = np.sin(x)

# Create and display the plot
plt.plot(x, y)
plt.title("A Simple Sine Wave")
plt.xlabel("X-axis")
plt.ylabel("Y-axis")
plt.show()
