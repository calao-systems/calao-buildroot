#############################################################
#
# mplayer
#
#############################################################
MPLAYER_VERSION:=1.0rc2
MPLAYER_SOURCE:=MPlayer-$(MPLAYER_VERSION).tar.bz2
MPLAYER_SITE:=http://www7.mplayerhq.hu/MPlayer/releases
MPLAYER_DIR:=$(BUILD_DIR)/MPlayer-$(MPLAYER_VERSION)
MPLAYER_CAT:=$(BZCAT)
MPLAYER_BINARY:=mplayer
MPLAYER_TARGET_BINARY:=usr/bin/$(MPLAYER_BINARY)

MPLAYER_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBMAD),libmad)

# mplayer needs pcm+mixer support, but configure fails to check for it
ifeq ($(BR2_PACKAGE_ALSA_LIB)$(BR2_PACKAGE_ALSA_LIB_MIXER)$(BR2_PACKAGE_ALSA_LIB_PCM),yyy)
MPLAYER_DEPENDENCIES += alsa-lib
MPLAYER_ALSA:=--enable-alsa
else
MPLAYER_ALSA:=--disable-alsa
endif

ifeq ($(BR2_ENDIAN),"BIG")
MPLAYER_ENDIAN:=--enable-big-endian
else
MPLAYER_ENDIAN:=--disable-big-endian
endif

# mplayer unfortunately uses --disable-largefileS, so we cannot use
# DISABLE_LARGEFILE
ifeq ($(BR2_LARGEFILE),y)
MPLAYER_LARGEFILE:=--enable-largefiles
else
# dvdread/dvdcss requires largefile support
MPLAYER_LARGEFILE:=--disable-largefiles \
		   --disable-dvdread-internal \
		   --disable-libdvdcss-internal
endif

ifeq ($(BR2_PACKAGE_SDL),y)
MPLAYER_SDL:=--enable-sdl --with-sdl-config=$(STAGING_DIR)/usr/bin/sdl-config
MPLAYER_DEPENDENCIES += sdl
else
MPLAYER_SDL:=--disable-sdl
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
MPLAYER_FREETYPE:= \
	--enable-freetype \
	--with-freetype-config=$(STAGING_DIR)/usr/bin/freetype-config
MPLAYER_DEPENDENCIES += freetype
else
MPLAYER_FREETYPE:=--disable-freetype
endif

ifeq ($(BR2_i386),y)
# This seems to be required to compile some of the inline asm
MPLAYER_CFLAGS:=-fomit-frame-pointer
endif

$(DL_DIR)/$(MPLAYER_SOURCE):
	$(call DOWNLOAD,$(MPLAYER_SITE),$(MPLAYER_SOURCE))

$(MPLAYER_DIR)/.unpacked: $(DL_DIR)/$(MPLAYER_SOURCE)
	$(MPLAYER_CAT) $(DL_DIR)/$(MPLAYER_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MPLAYER_DIR) package/multimedia/mplayer/ mplayer-$(MPLAYER_VERSION)\*.patch\*
	$(CONFIG_UPDATE) $(MPLAYER_DIR)
	touch $@

$(MPLAYER_DIR)/.configured: $(MPLAYER_DIR)/.unpacked
	(cd $(MPLAYER_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CFLAGS="$(TARGET_CFLAGS) $(MPLAYER_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		./configure \
		--prefix=/usr \
		--confdir=/etc \
		--target=$(GNU_TARGET_NAME) \
		--host-cc=$(HOSTCC) \
		--cc="$(TARGET_CC)" \
		--as=$(TARGET_CROSS)as \
		--with-extraincdir=$(STAGING_DIR)/usr/include \
		--with-extralibdir=$(STAGING_DIR)/lib \
		--charset=UTF-8 \
		--enable-mad \
		--enable-fbdev \
		$(MPLAYER_ENDIAN) \
		$(MPLAYER_LARGEFILE) \
		$(MPLAYER_SDL) \
		$(MPLAYER_FREETYPE) \
		$(MPLAYER_ALSA) \
		--enable-cross-compile \
		--disable-ivtv \
		--disable-tv \
		--disable-live \
		--enable-dynamic-plugins \
	)
	touch $@

$(MPLAYER_DIR)/$(MPLAYER_BINARY): $(MPLAYER_DIR)/.configured
	$(MAKE1) -C $(MPLAYER_DIR)
	touch -c $@

$(TARGET_DIR)/$(MPLAYER_TARGET_BINARY): $(MPLAYER_DIR)/$(MPLAYER_BINARY)
	$(INSTALL) -m 0755 -D $(MPLAYER_DIR)/$(MPLAYER_BINARY) $(TARGET_DIR)/$(MPLAYER_TARGET_BINARY)
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/$(MPLAYER_TARGET_BINARY)
	touch -c $@

mplayer: $(MPLAYER_DEPENDENCIES) $(TARGET_DIR)/$(MPLAYER_TARGET_BINARY)

mplayer-source: $(DL_DIR)/$(MPLAYER_SOURCE)

mplayer-unpacked: $(MPLAYER_DIR)/.unpacked

mplayer-clean:
	rm -f $(TARGET_DIR)/$(MPLAYER_TARGET_BINARY)
	-$(MAKE) -C $(MPLAYER_DIR) clean

mplayer-dirclean:
	rm -rf $(MPLAYER_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_MPLAYER),y)
TARGETS+=mplayer
endif