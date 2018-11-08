FROM ubuntu:xenial

ADD builder/ /builder/

VOLUME /output

RUN /builder/build.sh /output

CMD sleep 300

