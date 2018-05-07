FROM naamio/naamio:0.0

LABEL authors="Phil J. Łaszkowicz <phil@fillip.pro>"

RUN mkdir -p /usr/share/naamio/nuppu

COPY ./ /usr/share/naamio/nuppu

ENV NAAMIO_SOURCE=nuppu
ENV NAAMIO_TEMPLATES=nuppu/_templates/
ENV NAAMIO_PORT=8090

EXPOSE ${NAAMIO_PORT}

WORKDIR /usr/share/naamio/

ENTRYPOINT ["/usr/share/naamio/Naamio"]
