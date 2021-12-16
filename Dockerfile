FROM busybox as warchaeology

ARG VERSION=0.1.0-RC.6
RUN wget -O warc https://github.com/nlnwa/warchaeology/releases/download/v${VERSION}/warc_linux_x86_64 \
    && chmod +x warc


FROM norsknettarkiv/jhove-warc-report-parser:0.1.0 as jwrp


FROM python:3.10-alpine
LABEL maintainer="marius.beck@nb.no"

RUN apk add --no-cache jq curl gettext git tree

RUN pip install warctools

COPY --from=warchaeology /warc /usr/local/bin/warc

COPY --from=jwrp /jhove-warc-report-parser /usr/local/bin/jhove-warc-report-parser

WORKDIR /veidemann

CMD ["/bin/sh"]
