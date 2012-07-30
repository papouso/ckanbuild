#!/bin/sh

echo ""
read -p "Please enter the IP for the SOLR server? " SOLR
read -p "Please enter the IP for the DATABASE server? " DATABASE
read -p "Please enter the IP for the ELASTIC server? " ELASTIC

echo "Configuring network with: "
echo " SOLR -> $SOLR"
echo " DATABASE -> $DATABASE"
echo " ELASTIC -> $ELASTIC"
echo ""

while true; do
    read -p "Should we run with those values? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

function check_hosts() {
    if grep -q "$1" /etc/hosts
    then
        echo "$1 was found in /etc/hosts"
        exit
    else
        echo "$2 $1" | sudo tee -a /etc/hosts
    fi
}
check_hosts 'solrserver' $SOLR
check_hosts 'dbserver' $DATABASE
check_hosts 'elasticserver' $ELASTIC

APT="apt-get -y --quiet"

sudo $APT update
sudo $APT upgrade

sudo $APT install htop
sudo $APT install apache2
sudo $APT install libapache2-mod-wsgi
sudo $APT install nginx

# libpq-dev and python-dev are required for psycopg2 but they'll
# also install gcc.
sudo $APT install python-virtualenv
sudo $APT install libpq-dev python-dev
