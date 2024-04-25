#!/bin/sh

set -e  # Exit immediately if a command files
set -u  # Treat unset variables as errors

. /etc/os-release

if [ "$ID" = "ubuntu" ]; then
	add-apt-repository -y ppa:git-core/ppa
fi

apt-get update
apt-get upgrade -y
apt-get install -y \
	build-essential \
	ca-certificates \
	curl \
	dnsutils \
	file \
	git \
	git-lfs \
	htop \
	jq \
	openssl \
	procps \
	shellcheck \
	software-properties-common \
	telnet \
	unzip \
	wget \
	whois \
	zip \
	zsh

# Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL "https://download.docker.com/linux/$ID/gpg" -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
add-apt-repository -y "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$ID $VERSION_CODENAME stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
