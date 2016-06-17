FROM ubuntu:latest
MAINTAINER cptactionhank <cptactionhank@users.noreply.github.com>


COPY ./root /

RUN RUNTMDEPS="supervisor dbus python-dbus dbus-x11 python libdbus-1-3 libdbus-glib-1-2 avahi-daemon nodejs git-core libnss-mdns libavahi-compat-libdnssd-dev"
RUN apt-get --quiet --yes --fix-missing update 
RUN apt-get dist-upgrade -y 
RUN apt-get --quiet --yes install curl gnupg-curl apt-transport-https 
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - 
RUN apt-get --quiet --yes install ${RUNTMDEPS} 
RUN rm -rf "/var/lib/apt/lists/*" 
RUN apt-get --quiet --yes autoclean 
RUN apt-get --quiet --yes autoremove 
RUN apt-get --quiet --yes clean

WORKDIR /opt
RUN apt-get install -y wget
RUN wget http://python.org/ftp/python/2.7.5/Python-2.7.5.tgz
RUN tar -xvf Python-2.7.5.tgz
WORKDIR /opt/Python-2.7.5
RUN apt-get install -y build-essential checkinstall
RUN apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
RUN apt-get install -y libavahi-compat-libdnssd-dev
RUN ./configure
RUN make

RUN mkdir /opt/hap-nodejs
WORKDIR /opt/hap-nodejs
RUN apt-get install -y nodejs
RUN apt-get install -y git
RUN git clone https://github.com/KhaosT/HAP-NodeJS.git .
RUN npm install -g node-gyp
RUN npm rebuild
RUN npm install --python=/opt/Python-2.7.5/python
