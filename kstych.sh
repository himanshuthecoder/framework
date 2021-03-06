#!/bin/bash

ARG1=${1:-localhost}
ARG2=${2:-localhost}
ARG3=${3:-127.0.0.1}

APIKEY=`cat /dev/urandom |head -c 32 | base64`

if [[ "$(docker images -q kstych/framework 2> /dev/null)" == "" ]]; then
  docker pull kstych/framework
fi

mkdir -p data/custom
mkdir -p data/var/lib/mysql
mkdir -p data/etc/letsencrypt
chmod -R 777 data

echo "/app" > data/custom/.gitignore
echo ".env" >> data/custom/.gitignore

if [ ! -f data/custom/.env ]; then

echo "APP_ENV=local
APP_DEBUG=false
APP_KEY=base64:$APIKEY

APP_URL=http://$ARG2
APP_NAME=App

APP_ADMIN_DEBUG=true
app_title=Framework
app_ip=$ARG3
app_masterpassword=yb9738z

asterisk_slaves=$ARG3:1001:2000:1:240
asterisk_manager=$ARG3
asterisk_extensions=\"31332,_62XXXX!\"

domain_alisas=
APP_Multiple_Logins=yes
kDialer_keeplocalconf=0
app_developer=siddharth@kstych.com

LOG_CHANNEL=stack

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=app_test
DB_USERNAME=root
DB_PASSWORD=yb9738z

BROADCAST_DRIVER=log
CACHE_DRIVER=database
SESSION_DRIVER=database
SESSION_LIFETIME=43200
QUEUE_CONNECTION=database

MAIL_MAILER=log
MAIL_HOST=email-smtp.us-east-1.amazonaws.com
MAIL_PORT=587
MAIL_USERNAME=
MAIL_PASSWORD=
MAIL_FROM_ADDRESS=siddharth@kstych.com
MAIL_FROM_NAME=Framework

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=bucket-name
AWS_URL=

FILESYSTEM_DRIVER=local
FILESYSTEM_CLOUD=s3
" > data/custom/.env

fi


echo "Running Framework Image"
docker run --rm -it --shm-size=2gb -v `pwd`/data/var/lib/mysql:/var/lib/mysql:Z -v `pwd`/data/custom:/home/Kstych/Framework/custom:Z -v `pwd`/data/etc/letsencrypt:/etc/letsencrypt:Z -p 80:80 -p 443:443 -e KSTYCH_LICENSE="$ARG1" -e KSTYCH_DOMAIN="$ARG2" kstych/framework
