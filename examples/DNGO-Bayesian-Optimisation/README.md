# DNGO Bayesian Optimisation (FGMachine)

## Introduction

Bayesian optimisation is a global optimisation technique, which treats the function it must optimise as a random function. It places a prior on the function, and evaluates the function to collect data points. Each evaluation is used to update the posterior distribution over the function, which in turn is used to select the next point to evaluate. This allows Bayesian optimisation to be data-efficient, and hence it is a suitable technique for optimising hyperparameters of another system. Although this is usually performed with Gaussian processes, an alternative technique is to use Deep Networks for Global Optimization (DNGO) [1]. This example will utilise the bot7 library in order to optimise the 6-dimensional Hartmann function.

This example has been adapted from the [DNGO demo](https://github.com/j-wilson/bot7/blob/master/examples/dngo_demo.lua). **TO CHANGE:** `branin_noisy.py` has been set up to take command line arguments and save its results in a JSON file, whilst `fglab.py` acts as an intermediary between Spearmint and the function to optimise by using FGLab's API.

## Requirements

- [Torch7](http://torch.ch/)
- [gpTorch7](https://github.com/j-wilson/gpTorch7)
- [bot7](https://github.com/j-wilson/bot7)
- [LuaSocket](http://w3.impa.br/~diego/software/luasocket/)

## Instructions

1. Set up [FGLab](https://github.com/Kaixhin/FGLab/blob/master/examples/DNGO-Bayesian-Optimisation).
1. Insert the [project](project.json) into FGMachine's `projects.json` file, using the project ID from FGLab.

**TO CHANGE**

1. Within `fglab.py`, replace `<Project ID>` with the same project ID, `<FGLab URL>` with the address of FGLab, and `<Spearmint helper URL>` with the address of `fglab.py`'s Flask server. By default, Flask uses port 5000.
1. Change into the Spearmint directory and start a MongoDB daemon, e.g. `mongod --fork --logpath mongodb.log --dbpath db`. The database folder (in this case `db`) must exist.
1. Run Spearmint with `python main.py <Path to Bayesian-Optimisation folder>`. Spearmint will continue to submit jobs to get results to fit to a Gaussian Process, which it uses to find the optimal solution.

## Citations

[1] Snoek, J., Rippel, O., Swersky, K., Kiros, R., Satish, N., Sundaram, N., Patwary, M., Ali, M. & Adams, R. P. (2015). Scalable Bayesian Optimization Using Deep Neural Networks. *arXiv preprint* arXiv:1502.05700.
