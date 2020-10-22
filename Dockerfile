FROM norsknettarkiv/gowarc:latest as gowarc

FROM norsknettarkiv/jhove-warc-report-parser:0.1.0 as jwrp

FROM python:3.9-alpine

RUN apk add --no-cache jq

RUN pip install warctools

COPY --from=gowarc /warc /usr/local/bin/warc

COPY --from=jwrp /jhove-warc-report-parser /usr/local/bin/jhove-warc-report-parser

CMD ["/bin/sh"]
