FROM naamio/naamio:edge

LABEL authors="Gabrielle Iskandar <gabiskandar@gmail.com>"
LABEL maintainer="Gabrielle Iskandar <gabiskandar@gmail.com>"
LABEL version="0.0"

RUN mkdir -p /usr/share/naamio/nuppu

COPY .build/ /usr/share/naamio/nuppu

ENV NAAMIO_SOURCE=nuppu
ENV NAAMIO_TEMPLATES=nuppu/stencils/
ENV NAAMIO_PORT=8090

EXPOSE ${NAAMIO_PORT}

WORKDIR /usr/share/naamio/

ENTRYPOINT ["/usr/share/naamio/Naamio"]
