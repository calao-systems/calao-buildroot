################################################################################
#
# xproto_inputproto -- X.Org Input protocol headers
#
################################################################################

XPROTO_INPUTPROTO_VERSION = 2.0
XPROTO_INPUTPROTO_SOURCE = inputproto-$(XPROTO_INPUTPROTO_VERSION).tar.bz2
XPROTO_INPUTPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_INPUTPROTO_AUTORECONF = NO
XPROTO_INPUTPROTO_INSTALL_STAGING = YES
XPROTO_INPUTPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,package/x11r7,xproto_inputproto))
$(eval $(call AUTOTARGETS,package/x11r7,xproto_inputproto,host))
