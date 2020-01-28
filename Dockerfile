##  Download base image ubuntu 18.04
FROM ubuntu:18.04

##  Labels
LABEL image="wrenchilot/unbound-pihole:4.3.2_ubuntu"
LABEL maintainer="shawn@floatingboy.org"
LABEL url="https://github.com/wrenchpilot/Unbound-PiHole-Docker"

##  Environment
ENV IPv6 False
ENV VERSION v4.3.2
ENV ARCH amd64

##  Create user
RUN useradd -ms /bin/bash installer

##  Update Ubuntu Software repository
RUN apt-get update

##  Install software
RUN apt-get install -y unbound net-tools nano wget curl procps ca-certificates git apt-utils dialog dhcpcd5 iproute2 whiptail

EXPOSE 53/tcp 53/udp
EXPOSE 5353/tcp 5353/udp
EXPOSE 67/udp
EXPOSE 80
EXPOSE 443

##  Setup configs
COPY pi-hole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY resolv.conf /etc/resolv.conf

RUN git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole
RUN "/Pi-hole/automated install/basic-install.sh"

##  Test unbound
HEALTHCHECK CMD dig @127.0.0.1 pi.hole -p 5353 || exit 1

## Sheel
SHELL ["/bin/bash", "-c"]