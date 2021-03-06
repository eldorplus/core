#!/usr/bin/env bash

DIR="/home/vagrant/radio"

# set up icecast
wget -qO - http://icecast.org/multimedia-obs.key | sudo apt-key add -
echo "deb http://download.opensuse.org/repositories/multimedia:/xiph/xUbuntu_14.04/ ./" >> /etc/apt/sources.list.d/icecast.list

# set up elasticsearch
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" >> /etc/apt/sources.list.d/elasticsearch-2.x.list

# add dependencies for python packages
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y ezstream elasticsearch icecast2 python-dev lame flac mpg123 libmysqlclient-dev libshout3-dev libffi-dev

cp "${DIR}/components/icecast/config.xml" /etc/icecast2/icecast.xml
cp "${DIR}/components/icecast/icecast2.defaults" /etc/default/icecast2

service icecast2 start

# upgrade pip because ouch
curl -sS https://bootstrap.pypa.io/get-pip.py | python
pip install -U ndg-httpsclient virtualenv

function install-virtualenv() {
  local virtualenv=$1
  cd "${DIR}/components/${virtualenv}"
  virtualenv .
  source bin/activate
  python setup.py install
  deactivate
}

install-virtualenv verifier
# install-virtualenv hanyuu



