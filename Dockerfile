FROM ubuntu:20.04 AS build

ARG DEBIAN_FRONTEND=noninteractive

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -yq locales && \
  locale-gen en_US.UTF-8 && \
  useradd -s /bin/bash -d /home/irssi -m irssi && \
  apt-get install -yq irssi irssi-scripts screen openssh-server && \
  apt-get install -yq perl build-essential curl wget unzip && \
  apt-get install -yq deluge-console python3-libtorrent && \
  apt-get install -yq python3.8 python3-pip git && \
  cpan Archive::Zip Net::SSLeay HTML::Entities XML::LibXML Digest::SHA JSON JSON::XS && \
  cd /root && \
  git clone https://github.com/mreilaender/deluge-send-torrent.git deluge-send-torrent && \
  cd deluge-send-torrent && \
  bash -c 'pip3 install .'

USER irssi

RUN mkdir -p ~/.irssi/scripts/autorun && \
  cd ~/.irssi/scripts && \
  echo "https://github.com/autodl-community/autodl-irssi/releases/download/2.6.2/autodl-irssi-v2.6.2.zip" | xargs wget --quiet -O autodl-irssi.zip && \
  unzip -o autodl-irssi.zip && \
  rm autodl-irssi.zip && \
  cp autodl-irssi.pl autorun/ && \
  mkdir -p ~/.autodl && \
  touch ~/.autodl/autodl.cfg

VOLUME /home/irssi/.autodl

ENTRYPOINT ["/usr/bin/irssi"]

