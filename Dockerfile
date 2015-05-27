FROM ubuntu:precise

# Install dependencies
RUN apt-get update &&  \
    DEBIAN_FRONTEND=noninteractive apt-get -y install unzip python python-pip python-dev libsqlite3-dev cron \
    libcurl4-openssl-dev libldap2-dev libsasl2-dev libxml2-dev libxslt-dev gcc nginx-light supervisor sqlite3 && \
    apt-get clean && \
    rm /var/lib/apt/lists/*_*

# Download rattic
ENV RATTIC_VERSION 1.3.1
ADD https://github.com/tildaslash/RatticWeb/archive/v${RATTIC_VERSION}.tar.gz /opt/rattic.tar.gz

# Unpack rattic
RUN mkdir -p /opt/rattic && tar xvfz /opt/rattic.tar.gz -C /opt/rattic --strip-components=1

# Copy config
ADD ./files/rattic.conf /opt/local.dist.cfg

# Install dependencies for both rattic and gunicorn
RUN cd /opt/rattic/ && pip install -r requirements-base.txt
RUN pip install gevent gunicorn logstash-formatter
COPY ./files/gunicorn_logging.conf /opt/rattic/logging.config

# Copy run script
ADD ./files/init_and_gunicorn.sh /opt/rattic/run.sh
RUN chmod 755 /opt/rattic/run.sh

# Trick used by the official nginx Dockerfile to redirect logs to stdout
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Copy the nginx and supervisord configuration
COPY ./files/nginx.conf /etc/nginx/nginx.conf
COPY ./files/supervisord.conf /etc/supervisor/supervisord.conf

# Run the backup command at 4:30
RUN echo '30 4 * * * root cd /opt/rattic && env - `cat /dev/shm/env.txt` /usr/bin/python manage.py backup' > /etc/crontab

# Copy supervisor config
EXPOSE 80

# Default command
CMD ["/usr/bin/supervisord"]
