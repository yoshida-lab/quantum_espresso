FROM nvidia/cuda:10.1-devel

LABEL maintainer="TsumiNa <liu.chang.1865@gmail.com>"


# Install some basic utilities
RUN apt-get update && apt-get install -y \
    gcc \
    gfortran \
    curl \
    ca-certificates \
    sudo \
    # libtool \
    # libtool-bin \
    # # mpich \
    libopenmpi-dev \
    libscalapack-openmpi-dev \
    libopenblas-dev \
    openmpi-bin \
    openmpi-common \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and switch to it
# All users can use /home/user as their home directory
RUN adduser --disabled-password --gecos '' --shell /bin/bash user &&\
    echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user &&\
    mkdir /workspace && chown -R user:user /workspace &&\
    chmod 777 -R /home/user && chmod 777 -R /workspace
USER user
ENV HOME=/home/user
WORKDIR /workspace

ARG qe=q-e-qe-6.4.1
ARG QE_DIR=/home/user/qe

# ARG elpa=elpa-2019.05.001
# ARG ELPA_DIR=/home/user/elpa
ENV PATH=/home/user/bin:$PATH
ENV PARA_PREFIX=mpiexec
ENV OMP_num=4
ENV PARA_POSTFIX="-n ${OMP_num}"

# install psxe
# COPY . .

# install elpa
# RUN tar -xzf ${elpa}.tar.gz && cd $elpa && \
#     ./configure --prefix=$ELPAROOT \
#     --enable-openmp \
#     --with-mpi=no \
#     --enable-gpu \
#     --disable-sse \
#     --disable-avx \
#     --disable-avx2 \
#     FC=gfortran \
#     --with-cuda-path="/usr/local/cuda" \
#     && \
#     make -j && \
#     sudo make install && \
#     cd ..

RUN \
    curl -O https://gitlab.com/QEF/q-e/-/archive/qe-6.4.1/${qe}.tar.gz &&\
    tar -xzf ${qe}.tar.gz && cd $qe && \
    ./configure --prefix=$HOME \
    # --enable-openmp \
    # --enable-parallel=no \
    # --with-elpa-include="/include/elpa_onenode_openmp-2019.05.001/elpa" \
    # --with-elpa-lib="lib/libelpa_onenode_openmp.a" \
    # --with-elpa-version=2016 \
    && \
    make -j pwall tddfpt && sudo make install && \
    cd .. && rm -rf $qe* 

CMD [ "bash" ]



