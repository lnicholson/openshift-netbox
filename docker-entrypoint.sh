#!/bin/bash
set -e


###################################################################################
###################### PREP POSTGRES CONFIG FILE  #################################
###################################################################################

#Insert DB_NAME
sed -i -e "s/DB_NAME/$(echo $DB_NAME)/g" /opt/netbox/netbox/netbox/configuration.py

#Insert DB_USER
sed -i -e "s/DB_USER/$(echo $DB_USER)/g" /opt/netbox/netbox/netbox/configuration.py

#Insert DB_PASSWORD
sed -i -e "s/DB_PASSWORD/$(echo $DB_PASSWORD)/g" /opt/netbox/netbox/netbox/configuration.py

#Insert DB_HOST
sed -i -e "s/DB_HOST/$(echo $DB_HOST)/g" /opt/netbox/netbox/netbox/configuration.py

#Insert DJANGO_SECRET_KEY
sed -i -e "s/DJANGO_SECRET_KEY/$(echo $DJAGNO_SECRET_KEY)/g" /opt/netbox/netbox/netbox/configuration.py

#Insert FQDN
sed -i -e "s/FQDN/$(echo $FQDN)/g" /opt/netbox/netbox/netbox/configuration.py

###################################################################################
##########################      PREP NGINX    #####################################
###################################################################################

sed -i -e "s/FQDN/$(echo $FQDN)/g" /opt/netbox/netbox/netbox/nginx.conf

###################################################################################
##########################      RUN CMD    ########################################
###################################################################################
/usr/sbin/nginx
uwsgi --ini /opt/netbox/netbox/netbox/uwsgi.ini
sleep infinity

#exec "$@"


