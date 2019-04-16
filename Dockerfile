FROM debian

#Actualizo el contenedor
RUN	apt-get update; apt-get -y  upgrade

#Instalalndo dependencias

RUN	export DEBIAN_FRONTEND="noninteractive"; apt-get -y install acl attr autoconf bind9utils bison build-essential \
	debhelper dnsutils docbook-xml docbook-xsl flex gdb libjansson-dev krb5-user \
	libacl1-dev libaio-dev libarchive-dev libattr1-dev libblkid-dev libbsd-dev \
	libcap-dev libcups2-dev libgnutls28-dev libgpgme11-dev libjson-perl   libldap2-dev \
	libncurses5-dev libpam0g-dev libparse-yapp-perl  libpopt-dev libreadline-dev \
	nettle-dev perl perl-modules pkg-config   python-all-dev python-crypto python-dbg \
 	python-dev python-dnspython   python3-dnspython python-gpgme python3-gpgme python-markdown \
	python3-markdown   python3-dev xsltproc zlib1g-dev 



#Copiando archivos necesarios
ADD	files/samba-4.8.3.tar.gz /usr/src
#RUN	ls -la /usr/src/; 
	#tar -xvf /usr/src/samba-4.8.3.tar -C /usr/src/
	

#Compilando 
RUN	cd /usr/src/samba-4.8.3; ./configure --systemd-install-services --prefix=/usr --enable-fhs --with-statedir=/state \
	--with-privatedir=/private --with-bind-dns-dir=/dns  --with-cachedir=/var --with-logfilebase=/log  \
	--with-piddir=/var/run --with-configdir=/config --jobs=`nproc --all`

RUN	cd /usr/src/samba-4.8.3; make --jobs=`nproc --all`; \
	cd /usr/src/samba-4.8.3; make install

#Borrando sources
RUN	rm -rf /usr/src/samba-*

#Creando directorios
RUN	mkdir /sysvol; mkdir /services
ADD 	files/ns-start /usr/bin/
ADD 	files/samba /etc/init.d
ADD	files/samba-ad-dc /etc/init.d
ADD	files/setdomain /usr/bin/

RUN	chmod +x /usr/bin/ns-start; \
	chmod +x /etc/init.d/samba; \
	chmod +x /etc/init.d/samba-ad-dc; \
	chmod +x /usr/bin/setdomain




#AVAHI 
RUN 	apt-get -y install avahi-daemon cron; \
	rm -rf /etc/avahi/services; \
	ln -s /services /etc/avahi/

ADD	files/smb-config.tgz  /opt/



ENTRYPOINT	["/usr/bin/ns-start"] 
