FROM golang:alpine as gowarc

ARG VERSION=v1.0.0-alpha.12

RUN apk add --no-cache git
RUN git clone https://github.com/nlnwa/gowarc -b ${VERSION} --depth=1 src/gowarc
WORKDIR /go/src/gowarc
RUN go install ./cmd/...


FROM norsknettarkiv/jhove-warc-report-parser:0.1.0 as jwrp


FROM golang:alpine as warchaeology

RUN apk add --no-cache git
RUN git clone https://github.com/nlnwa/warchaeology --depth=1 src/warchaeology
WORKDIR /go/src/warchaeology
RUN go install ./cmd/...


FROM python:3.9-alpine

RUN apk add --no-cache jq curl gettext git tree

RUN pip install warctools

COPY --from=gowarc /go/bin/warc /usr/local/bin/warc

COPY --from=jwrp /jhove-warc-report-parser /usr/local/bin/jhove-warc-report-parser

COPY --from=warchaeology /go/bin/warchaeology /usr/local/bin/warchaeology

WORKDIR /veidemann

CMD ["/bin/sh"]
