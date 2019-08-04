FROM ubuntu:18.04
COPY build-sys.sh /tmp/
RUN /tmp/build-sys.sh
COPY download-deps.sh /tmp/
RUN /tmp/download-deps.sh
COPY build-deps.sh /tmp/
RUN /tmp/build-deps.sh
ENTRYPOINT bash
