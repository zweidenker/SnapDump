FROM ubuntu:18.04

RUN \
  apt-get update && \
  apt-get install -y curl unzip libgit2-26 && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/ \
    && cd /opt \
    && curl get.pharo.org/64/70+vm | bash

RUN mv /opt/Pharo.image /opt/SnapDump.image
RUN mv /opt/Pharo.changes /opt/SnapDump.changes

COPY start.st /opt/

ARG CACHEBUST=1
RUN \
    /opt/pharo /opt/SnapDump.image eval --save "Metacello new repository: 'github://zweidenker/SnapDump/source'; baseline: #SnapDump; load: #('server')" && \
    /opt/pharo /opt/SnapDump.image eval --save "LGitLibrary class compile: 'startUp: isImageStarting'" && \
    rm -rf /opt/pharo-local

RUN \
  apt-get -y remove --purge unzip libgit2-26 && \
  apt-get -y autoremove --purge && \
  apt-get clean

WORKDIR /opt

CMD "/opt/pharo" "--mmap" "64m" "/opt/SnapDump.image" "--no-default-preferences" "st" "/opt/start.st"

EXPOSE 5555

HEALTHCHECK CMD curl --fail -H 'Connection: close' http://localhost:5555/health/sunit/SnapDumpHealth || exit 1
