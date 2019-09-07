FROM debian:buster

#Actualizo el contenedor
RUN	apt-get update; apt-get -y  upgrade

#Instalalndo dependencias

RUN	export DEBIAN_FRONTEND="noninteractive"; apt-get -y install samba acl


#Creando directorios
RUN	mkdir /sysvol; mkdir /services
ADD 	files/ns-start /usr/bin/
ADD 	files/samba /etc/init.d
ADD	 	files/samba-ad-dc /etc/init.d
ADD		files/setdomain /usr/bin/

RUN	chmod +x /usr/bin/ns-start; \
	chmod +x /etc/init.d/samba; \
	chmod +x /etc/init.d/samba-ad-dc; \
	chmod +x /usr/bin/setdomain; \
	tar -czvf /opt/var-samba.tgz /var/lib/samba; \
	rm -rf /var/lib/samba; \
	rm -rf /etc/samba; \
	mkdir -p /data /config /shares; \
	ln -s /config /etc/samba; \
	ln -s /data /var/lib/samba




#AVAHI 
RUN 	apt-get -y install avahi-daemon cron; \
		rm -rf /etc/avahi/services; \
		ln -s /services /etc/avahi/

ADD		files/smb-config.tgz  /opt/



ENTRYPOINT	["/usr/bin/ns-start"] 
