#!/bin/bash -e

RATTIC_CONFIG_PATH=/opt/rattic/conf/local.cfg

if [ ! -f ${RATTIC_CONFIG_PATH} ]; then
  mkdir -p $(dirname ${RATTIC_CONFIG_PATH})
  sed "s/%SECRETKEY%/$(openssl rand -base64 48 | cut -c1-32 | tr '/' '-')/g" /opt/local.dist.cfg > ${RATTIC_CONFIG_PATH}
  cd /opt/rattic/ && ./manage.py syncdb --noinput && ./manage.py migrate --all
  echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'rattic')" | ./manage.py shell
  echo "ALLOWED_HOSTS = ['127.0.0.1', 'localhost', 'rattic.service.dsd.io']" >> /opt/rattic/ratticweb/settings.py
fi

env > /dev/shm/env.txt

gunicorn ratticweb.wsgi -b 127.0.0.1:8000 -k gevent --log-config logging.config
