FROM alpine as warc-ip-corrector

RUN apk add --no-cache git

ARG ZIG_VERSION=linux-x86_64-0.9.0-dev.858+f1f28af18
ARG ZIG_SHA256=ae4d26eccf7f69fb9b4968223219f4b00b414541a269196305704961d3caf8b3
ARG ZIG_BUILD=https://ziglang.org/builds/zig-${ZIG_VERSION}.tar.xz

RUN ZIG=$(basename ${ZIG_BUILD}) \
; wget ${ZIG_BUILD} \
&& echo "${ZIG_SHA256}  ${ZIG}" | sha256sum -c \
&& tar xvf ${ZIG} -C /usr/local/share \
&& ln -s /usr/local/share/zig-${ZIG_VERSION}/zig /usr/local/bin/zig

ARG WARC_IP_CORRECTOR_REPO=https://github.com/nlnwa/warc-ip-corrector.git

RUN git clone --recurse-submodules --depth 1 ${WARC_IP_CORRECTOR_REPO} \
&& cd warc-ip-corrector \
&& zig build


FROM norsknettarkiv/gowarc:latest as gowarc

FROM norsknettarkiv/jhove-warc-report-parser:0.1.0 as jwrp

FROM python:3.9-alpine

RUN apk add --no-cache jq curl gettext git tree

RUN pip install warctools

COPY --from=gowarc /warc /usr/local/bin/warc

COPY --from=jwrp /jhove-warc-report-parser /usr/local/bin/jhove-warc-report-parser

COPY --from=warc-ip-corrector /warc-ip-corrector/zig-out/bin/warc-ip-corrector /usr/local/bin/warc-ip-corrector

WORKDIR /veidemann

CMD ["/bin/sh"]
