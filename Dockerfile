FROM busybox as warchaeology

ARG WARCHAEOLOGY_VERSION=1.1.0

RUN wget https://github.com/nlnwa/warchaeology/releases/download/v${WARCHAEOLOGY_VERSION}/checksums.txt
RUN wget https://github.com/nlnwa/warchaeology/releases/download/v${WARCHAEOLOGY_VERSION}/warchaeology_Linux_x86_64.tar.gz
RUN grep warchaeology_Linux_x86_64.tar.gz < checksums.txt | sha256sum -c -
RUN tar xvzf warchaeology_Linux_x86_64.tar.gz && chmod +x warc


FROM python:3.12-slim-bookworm

LABEL maintainer="marius.beck@nb.no"

RUN apk add --no-cache jq curl gettext git tree
RUN pip install warctools
COPY --from=warchaeology /warc /usr/local/bin/warc
COPY --from=jwrp /jhove-warc-report-parser /usr/local/bin/jhove-warc-report-parser

WORKDIR /veidemann

CMD ["/bin/sh"]
