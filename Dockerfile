###############################################################
# NAME: netbox-openshift
# Purpose:  An Openshift implimentation of netbox
# Notes: This is a fully contained version of Netbox that has
#        been prepared for the Openshift platform
# Netbox Documentation: http://netbox.readthedocs.io/en/stable/ 
###############################################################

# Using Centos 7 as base
FROM centos:7

# Maintained be
MAINTAINER smacktrace <smacktrace942@gmail.com>

#Dependencies
RUN yum install -y epel-release
RUN yum install -y gcc \
        git \
        python34 \ 
        python34-devel \
        python34-setuptools \
        libxml2-devel \
        libxslt-devel \
        libffi-devel \
        graphviz \
        openssl-devel \
        redhat-rpm-config \
        openldap-devel \
	nginx \
	uwsgi \
	uwsgi-plugin-python3 \
	&& yum clean all -y
	

#Contents of netbox 
ADD /netbox /opt/netbox

#Pip install files
ADD /pip /opt/pip

COPY nginx.conf /etc/nginx/nginx.conf

#Install PIP3 (PYTHON) dependencies
RUN python3 /opt/pip/get-pip.py \
	&& pip3 install -r /opt/netbox/requirements.txt \
	&& pip3 install napalm django-auth-ldap uwsgi 

RUN python3 /opt/netbox/netbox/manage.py collectstatic --no-input
	
#TEMP ENV VARS    ### REMOVE for openshift
ENV DB_NAME netbox
ENV DB_USER netbox
ENV DB_PASSWORD netbox
ENV DB_HOST netboxdb
ENV DJAGNO_SECRET_KEY j8m06GIBSh&dD1z*c5Cq$i9RyE47@H#ub^nKV_(LN+-f=w!agx
ENV FQDN localhost


#Create and prepare docker entrypoint
ADD docker-entrypoint.sh /sbin
RUN chmod +x /sbin/docker-entrypoint.sh \
        && mkdir -p /var/log/netbox \
        && usermod -a -G root nginx 


#MAKE SURE TO ADD LDAP STUFF http://netbox.readthedocs.io/en/stable/installation/ldap/

RUN chmod -R 777 /var/log/netbox && \
	chmod 750 /etc/nginx && \
	chmod 770 /run && \
	chgrp -R 0 /var /opt  && \
	chmod -R g=u /var /opt && \
	chmod g=u /etc/passwd

EXPOSE 8000
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["nginx", "-g", "daemon off;"]
USER 1001
