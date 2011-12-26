#############################################################
#
# eibd
#
#############################################################

EIBD_VERSION:=0.0.4
EIBD_SOURCE = bcusdk_${EIBD_VERSION}.tar.gz
EIBD_SITE = http://www.auto.tuwien.ac.at/~mkoegler/eib/
EIBD_INSTALL_STAGING = YES
EIBD_INSTALL_TARGET = YES
EIBD_CONF_OPT =  --enable-onlyeibd --enable-ft12 --enable-pei16 \
		 --enable-eibnetip --enable-eibnetipserver \
		 --enable-eibnetiptunnel --without-pth-test
EIBD_DEPENDENCIES = libpthsem

$(eval $(call AUTOTARGETS,package,eibd))
