# Dockerfile para criacao do bootnode de controle da rede ethereum   
# Autor: Julio Cesar Torres <julio.torres@kryptogarten.ca> 
# Data : 2020-06-06
#

FROM ubuntu:xenial

LABEL "maintainer" = "Julio Torres <julio.torres@kryptogarten.ca>""

RUN apt-get update \ 
     && apt-get install -y wget \ 
     && rm -rf /var/lib/apt/lists/*

WORKDIR "/opt"
# Binario equivalente a instalacao em Raspberry Pi - Geth & Tools 1.9.15
# https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-arm7-1.9.15-0f77f34b.tar.gz
ARG BINARY="geth-alltools-linux-arm7-1.9.15-0f77f34b.tar.gz"
RUN wget "https://gethstore.blob.core.windows.net/builds/${BINARY}"
RUN tar -xzvf ${BINARY} --strip 1 
RUN rm ${BINARY}

ENV nodekeyhex=""
CMD exec ./bootnode -nodekeyhex ${nodekeyhex}

EXPOSE 30301/UDP
EXPOSE 30303/UDP