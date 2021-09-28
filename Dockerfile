FROM norsknettarkiv/jhove-warc-report-parser:0.1.0 as jwrp

FROM golang:alpine as warchaeology

RUN apk add --no-cache git

RUN git clone https://github.com/nlnwa/warchaeology --depth=1 /go/src/warchaeology
WORKDIR /go/src/warchaeology
RUN GOPROXY=proxy.golang.org go install


FROM python:3.9-alpine

RUN apk add --no-cache jq curl gettext git tree

RUN pip install warctools

COPY --from=gowarc /go/bin/warc /usr/local/bin/warc

COPY --from=jwrp /jhove-warc-report-parser /usr/local/bin/jhove-warc-report-parser

COPY --from=warchaeology /go/bin/warchaeology /usr/local/bin/warc

WORKDIR /veidemann

CMD ["/bin/sh"]
