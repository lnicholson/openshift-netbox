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
	uwsgi-plugin-python3
	

#Contents of netbox 
ADD /netbox /opt/netbox

#Pip install files
ADD /pip /opt/pip

COPY nginx.conf /etc/nginx/nginx.conf
COPY uwsgi /etc/init.d/uwsgi

#Install PIP3 (PYTHON) dependencies
RUN python3 /opt/pip/get-pip.py
RUN pip3 install -r /opt/netbox/requirements.txt
RUN pip3 install napalm \
	django-auth-ldap \
        uwsgi
	
#TEMP ENV VARS    ### REMOVE for openshift
ENV DB_NAME netbox
ENV DB_USER netbox
ENV DB_PASSWORD netbox
ENV DB_HOST netboxdb
ENV DJAGNO_SECRET_KEY j8m06GIBSh&dD1z*c5Cq$i9RyE47@H#ub^nKV_(LN+-f=w!agx
ENV FQDN localhost


#Create and prepare the provision script
ADD docker-entrypoint.sh /sbin
RUN chmod +x /sbin/docker-entrypoint.sh \
        && mkdir -p /var/log/netbox

#MAKE SURE TO ADD LDAP STUFF http://netbox.readthedocs.io/en/stable/installation/ldap/
ENTRYPOINT [ "/sbin/docker-entrypoint.sh" ]
CMD ["/bin/bash"]
