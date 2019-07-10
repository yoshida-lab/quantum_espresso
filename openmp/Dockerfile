FROM frolvlad/alpine-miniconda3:python3.7

LABEL maintainer="TsumiNa <liu.chang.1865@gmail.com>"

RUN apk add --no-cache libgfortran bash libgomp

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
    # install qe
    echo "Installing qe..." &&\
    curl https://gitlab.com/QEF/q-e/-/archive/qe-6.4.1/q-e-qe-6.4.1.tar.bz2 | tar -xj && cd q-e-qe-6.4.1 && pwd && \
    ./configure --enable-openmp --enable-parallel=no && \
    make -j 4 pwall && \
    echo "installing..." && make install && make clean && cd .. && pwd && \
    # add pseudos potentials
    echo "Downloading potentials..." &&\
    mkdir /pseudo_dir && cd /pseudo_dir &&  \
    curl https://www.materialscloud.org/discover/data/discover/sssp/downloads/SSSP_precision_pseudos.tar.gz | tar -xvz &&\
    curl https://www.materialscloud.org/discover/data/discover/sssp/downloads/SSSP_efficiency_pseudos.tar.gz | tar -xvz &&\
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
    conda clean -tipsy && \
    su -- user && \
    umask 0

ENV HOME=/home/user
ENV ESPRESSO_PSEUDO=/pseudo_dir
USER user

CMD [ "python" ]



