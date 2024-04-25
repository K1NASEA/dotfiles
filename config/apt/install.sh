#!/bin/sh

set -e  # Exit immediately if a command files
set -u  # Treat unset variables as errors

. /etc/os-release

apt-get update
apt-get upgrade -y
apt-get install -y \
	build-essential \
	ca-certificates \
	curl \
	dnsutils \
	file \
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

# git
if [ "$ID" = "ubuntu" ]; then
	add-apt-repository -y ppa:git-core/ppa
fi
apt-get update
apt-get install -y \
	git \
	git-lfs

# Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL "https://download.docker.com/linux/$ID/gpg" -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
	https://download.docker.com/linux/$ID $VERSION_CODENAME stable" | \
	tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
