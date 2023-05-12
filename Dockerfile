FROM debian:latest

COPY --chmod=+x disk-filler.sh /usr/local/bin/disk-filler.sh

RUN mkdir -p /mnt/disk0

RUN /usr/local/bin/disk-filler.sh 


