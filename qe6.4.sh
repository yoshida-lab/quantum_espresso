#!/bin/bash

# activate intel compiler
. /opt/intel/compilers_and_libraries/linux/bin/compilervars.sh intel64

echo "download openmpi"
curl https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.bz2 | tar -xj
cd openmpi-4.0.1
./configure --with-cma="no" CC="icc" CXX="icpc" FC="ifort"
make -j 4 && make install && make clean

# echo "download qe"
# curl https://gitlab.com/QEF/q-e/-/archive/qe-6.4.1/q-e-qe-6.4.1.tar.bz2 | tar -xj
# cd q-e-qe-6.4.1
