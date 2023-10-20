FROM busybox as warchaeology
RUN wget -O - https://github.com/nlnwa/warchaeology/releases/download/v1.1.0/warchaeology_Linux_x86_64.tar.gz | tar xvz && chmod +x warc


FROM ghcr.io/nlnwa/jhove-warc-report-parser:0.1.2 as jwrp


FROM python:3.11-alpine
LABEL maintainer="marius.beck@nb.no"

RUN apk add --no-cache jq curl gettext git tree
RUN pip install warctools
COPY --from=warchaeology /warc /usr/local/bin/warc
COPY --from=jwrp /jhove-warc-report-parser /usr/local/bin/jhove-warc-report-parser

WORKDIR /veidemann

CMD ["/bin/sh"]
