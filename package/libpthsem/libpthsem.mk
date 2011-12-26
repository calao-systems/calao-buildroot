#############################################################
#
# libpthsem
#
#############################################################

LIBPTHSEM_VERSION = 2.0.8
LIBPTHSEM_SOURCE:=pthsem_$(LIBPTHSEM_VERSION).tar.gz
LIBPTHSEM_SITE = http://www.auto.tuwien.ac.at/~mkoegler/pth/
LIBPTHSEM_LIBTOOL_PATCH = NO
LIBPTHSEM_INSTALL_STAGING = YES
LIBPTHSEM_INSTALL_TARGET = YES
LIBPTHSEM_DEPENDENCIES = argp-standalone
$(eval $(call AUTOTARGETS,package,libpthsem))
