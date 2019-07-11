# Usage

Using openMPI version

```bash
docker run --rm -it --user $(id -u):$(id -g) --cap-add=SYS_PTRACE \
            -e OMPI_NUM=4 \
            -v <path/to/input>:/workspace \
            -v <path/to/pseudopotentials>/pseudo_dir \
            yoshidalab/quantum_espresso:openmpi bash
```

Using openMP version

```bash
docker run --rm -it --user $(id -u):$(id -g) \
            -v <path/to/input>:/workspace \
            -v <path/to/pseudopotentials>/pseudo_dir \
            yoshidalab/quantum_espresso:openmpi bash
```

# Compile qe with intel paraller studio

You can use intel c/fortran compiler for the QE compiling.
Doing this will bring you additional improvement on the performance.

```bash
export CPATH=$MKLROOT/include:$MKLROOT/include/fftw:$CPATH
export FPATH=$MKLROOT/include:$MKLROOT/include/fftw:$FPATH

./configure \
    CC=icc CXX=icpc \
    FC=ifort \
    CFLAGS="-O3 -no-prec-div -fp-model fast=2 -xSKYLAKE" \
    FFLAGS="-O3 -no-prec-div -fp-model fast=2 -xSKYLAKE -align array64byte -threads -heap-arrays 4096" \
    BLAS_LIBS="-lmkl_intel_lp64 -lmkl_sequential -lmkl_blas95_lp64 -lmkl_core" \
    LAPACK_LIBS="-lmkl_intel_lp64 -lmkl_sequential -lmkl_blas95_lp64 -lmkl_core -lmkl_lapack95_lp64" \
    FFT_LIBS="-lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lfftw3xf_gnu"
```

See also, https://www.misasa.okayama-u.ac.jp/~masami/pukiwiki/index.php?QE6.4.1_to_Fedora30
