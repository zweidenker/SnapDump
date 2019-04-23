FROM registry/pharo6

RUN apt-get update && apt-get install -y curl 

COPY SnapDump.image SnapDump.changes start.st /opt/

# Define working directory.
WORKDIR /opt

# Define default command.
CMD "/usr/bin/pharo6-64" "--mmap" "64m" "/opt/SnapDump.image" "--no-default-preferences" "st" "/opt/start.st"

EXPOSE 5555

HEALTHCHECK CMD curl --fail -H 'Connection: close' http://localhost:5555/health/sunit/ServerHealth || exit 1
