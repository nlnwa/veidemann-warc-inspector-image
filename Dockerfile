FROM norsknettarkiv/gowarc:latest as gowarc

FROM python:3.8-alpine

RUN pip install warctools

COPY --from=gowarc /warc /usr/local/bin/warc

CMD ["/bin/sh"]
