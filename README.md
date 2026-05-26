# Mix-Precision-Tucker-Decomposition

This repository contains MATLAB codes to reproduce the results presented in the paper:

**"Mixed Precision Compression of Tucker Decomposition"**  
by *Grey Ballard, Theo Mary, and Bhisham Dev Verma*. (Submitted, 2026).

## Repository Structure and Usage
- `mix_precision_hosvd.m` is the main script.
- The heat dataset is included in this repository. Other datasets should be downloaded separately.
- The script calls the `hosvd1` function from `hosvd1.m`.
- The repository includes the Chop library and the Tensor Toolbox required to run the codes.
- `Experimental_results/` contains the data and results corresponding to the figures in the paper.
