FROM frolvlad/alpine-miniconda3:python3.7

LABEL maintainer="TsumiNa <liu.chang.1865@gmail.com>"

ENV PARA_PREFIX=mpiexec
ENV OMP_num=4
ENV PARA_POSTFIX="-n ${OMP_num}"

RUN apk add --no-cache libgfortran bash openssh

WORKDIR /workspace

# add user
RUN echo "Creating user..." &&\
    adduser --disabled-password --gecos '' --shell /bin/sh user &&\
    chown -R user:user /workspace &&\
    chmod 777 -R /home/user && chmod 777 -R /workspace

# install build-dependencies
RUN apk add --no-cache -t build-dependencies \
    build-base \
    linux-headers \
    gfortran \
    curl \
    perl && \
    # install openmpi
    curl https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.bz2 | tar -xj && cd openmpi-4.0.1 &&\
    ./configure && \
    make -j 4 && make install && make clean && cd .. && \
    # install qe
    echo "Installing qe..." &&\
    curl https://gitlab.com/QEF/q-e/-/archive/qe-6.4.1/q-e-qe-6.4.1.tar.bz2 | tar -xj && cd q-e-qe-6.4.1 && \
    ./configure && \
    make -j pwall && make install && make clean && cd .. && \
    # add pseudos potentials
    echo "Downloading potentials..." &&\
    mkdir /pseudo_dir && cd /pseudo_dir &&  \
    mkdir SSSP_precision && mkdir SSSP_efficiency &&\
    curl https://www.materialscloud.org/discover/data/discover/sssp/downloads/SSSP_precision_pseudos.tar.gz | tar -xvz -C SSSP_precision &&\
    curl https://www.materialscloud.org/discover/data/discover/sssp/downloads/SSSP_efficiency_pseudos.tar.gz | tar -xvz -C SSSP_efficiency &&\
    chmod 777 -R /pseudo_dir && \ 
    # cleanup
    echo "Cleanup" &&\
    rm -rf /workspace/openmpi-4.0.1 /workspace/q-e-qe-6.4.1 && \
    apk del build-dependencies

# Install Miniconda
RUN conda update -n base -c defaults -y conda && \
    conda install -y \
    numpy=1.16.* \
    scipy=1.2.* \
    # pandas=0.24.* \
    joblib && \
    pip install -U ase ruamel.yaml && \
    conda clean -tipsy

ENV HOME=/home/user
USER user

CMD [ "python" ]



