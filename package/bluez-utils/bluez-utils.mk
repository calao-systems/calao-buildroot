#############################################################
#
# bluez-utils
#
#############################################################


BLUEZ_UTILS_VERSION = 3.36
BLUEZ_UTILS_SOURCE:=bluez-utils-$(BLUEZ_LIBS_VERSION).tar.gz
BLUEZ_UTILS_SITE = http://bluez.sf.net/download/
BLUEZ_UTILS_INSTALL_STAGING = YES
BLUEZ_UTILS_INSTALL_TARGET = YES

$(eval $(call AUTOTARGETS,package,bluez-utils))
