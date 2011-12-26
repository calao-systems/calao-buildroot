#############################################################
#
# linknx
#
#############################################################

LINKNX_VERSION:=0.0.1.27
LINKNX_SOURCE = linknx-${LINKNX_VERSION}.tar.gz
#LINKNX_SITE = http://belnet.dl.sourceforge.net/sourceforge/linknx/
LINKNX_SITE = http://sourceforge.net/projects/linknx/files/linknx/linknx-0.0.1.27/
LINKNX_INSTALL_STAGING = YES
LINKNX_INSTALL_TARGET = YES
LINKNX_CONF_OPT =  --without-log4cpp --without-pth-test
LINKNX_DEPENDENCIES = libpthsem

ifeq ($(BR2_PACKAGE_LUA),y)
LINKNX_DEPENDENCIES += lua
LINKNX_CONF_OPT += --with-lua
else
LINKNX_CONF_OPT += --without-lua
endif
 
$(eval $(call AUTOTARGETS,package,linknx))
