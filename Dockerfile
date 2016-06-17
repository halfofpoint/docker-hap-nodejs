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
RUN mkdir /opt/hap-nodejs
WORKDIR /opt/hap-nodejs
RUN apt-get install -y nodejs
RUN apt-get install -y git
RUN git clone https://github.com/KhaosT/HAP-NodeJS.git .
RUN npm install -g node-gyp
RUN npm rebuild
RUN npm install
RUN npm install mqtt

CMD ["/usr/bin/supervisord", "--nodaemon"]
