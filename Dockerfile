# --------------------------------------------------------------------
# | Usage Rec:
# | docker run --name web-app --publish 8080:80 --volume $(pwd):/var/www/html --detach payam/apache-php5
# |
# | 
# | 
# |

FROM ubuntu:latest

MAINTAINER Payam Naderi <naderi.payam@gmail.com>

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-mcrypt \
        php5-gd \
        php5-curl \
        php-pear \
        php-apc && \
    rm -rf /var/lib/apt/lists/*
RUN /usr/sbin/php5enmod mcrypt
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini

# Default Configuration
ENV ALLOW_OVERRIDE True ## enable mod_rewrite/AllowOverride

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh \
    sed -i -e 's/\r$//' /run.sh

# Configure www/html folder with sample app
RUN rm -rf /var/www && \
    mkdir /var/www
# Copy default/php test content
COPY www/ /var/www 
VOLUME /var/www

EXPOSE 80
CMD ["/run.sh"]

