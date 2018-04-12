#
# libwebsockets makefile for openwrt
#

include $(TOPDIR)/rules.mk

PLATFORM_TOPDIR:=$(TOPDIR)/../platform
PLATFORM_LIBWEBSOCKETS_DIR:=$(PLATFORM_TOPDIR)/libwebsockets

include $(PLATFORM_LIBWEBSOCKETS_DIR)/config.mk

PKG_RELEASE=$(PKG_SOURCE_VERSION)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/warmcat/libwebsockets.git
CMAKE_INSTALL:=1

PKG_LICENSE:=LGPL-2.1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_OPTIONS += -DLWS_OPENSSL_CLIENT_CERTS=/etc/ssl/certs
CMAKE_OPTIONS += -DLWS_OPENSSL_SUPPORT=ON
CMAKE_OPTIONS += -DLWS_WITH_SSL=ON
CMAKE_OPTIONS += -DLWS_WITHOUT_TESTAPPS=$(if $(CONFIG_PACKAGE_libwebsockets-examples),"OFF","ON")

# for wolfssl, define these in addition to LWS_OPENSSL_SUPPORT and
# edit package/libs/wolfssl/Makefile to include --enable-opensslextra
# CMAKE_OPTIONS += -DLWS_USE_WOLFSSL=ON
# CMAKE_OPTIONS += -DLWS_WOLFSSL_LIBRARIES=$(STAGING_DIR)/usr/lib/libwolfssl.so
# CMAKE_OPTIONS += -DLWS_WOLFSSL_INCLUDE_DIRS=$(STAGING_DIR)/usr/include

# for cyassl, define these in addition to LWS_OPENSSL_SUPPORT and
# edit package/libs/wolfssl/Makefile to include --enable-opensslextra
# CMAKE_OPTIONS += -DLWS_USE_CYASSL=ON
# CMAKE_OPTIONS += -DLWS_CYASSL_LIBRARIES=$(STAGING_DIR)/usr/lib/libcyassl.so
# CMAKE_OPTIONS += -DLWS_CYASSL_INCLUDE_DIRS=$(STAGING_DIR)/usr/include

# other options worth noting
# CMAKE_OPTIONS += -DLWS_WITHOUT_EXTENSIONS=ON
# CMAKE_OPTIONS += -DLWS_WITHOUT_DAEMONIZE=ON
# CMAKE_OPTIONS += -DLWS_WITHOUT_SERVER=ON
# CMAKE_OPTIONS += -DLWS_WITHOUT_DEBUG=ON

define Package/libwebsockets/Default
	SECTION:=libs
	CATEGORY:=Libraries
	TITLE:=libwebsockets
	DEPENDS:=+zlib +libopenssl +libpthread
endef

define Package/libwebsockets/Default/attributions
  This product includes software developed by the University of California, Berkeley and its contributors.
endef

define Package/libwebsockets
	$(call Package/libwebsockets/Default)
	TITLE+= (libraries)
endef

define Package/libwebsockets-examples/attributions
  $(call Package/libwebsockets/Default/attributions)
endef

define Package/libwebsockets/description
	libwebsockets
	This package contains libwebsocket libraries
endef

define Package/libwebsockets/attributions
  $(call Package/libwebsockets/Default/attributions)
endef

define Package/libwebsockets-examples
	$(call Package/libwebsockets/Default)
	DEPENDS:=libwebsockets
	TITLE+= (examples)
endef

define Package/libwebsockets-examples/description
	libwebsockets examples
	This package contains libwebsockets examples
endef

define Package/libwebsockets/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libwebsockets.so* $(1)/usr/lib/
endef

define Package/libwebsockets-examples/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/libwebsockets-test-client $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/libwebsockets-test-echo $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/libwebsockets-test-fraggle $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/libwebsockets-test-ping $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/libwebsockets-test-server $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/libwebsockets-test-server-extpoll $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/usr/share/libwebsockets-test-server
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/share/libwebsockets-test-server/favicon.ico $(1)/usr/share/libwebsockets-test-server/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/share/libwebsockets-test-server/leaf.jpg $(1)/usr/share/libwebsockets-test-server/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/share/libwebsockets-test-server/libwebsockets.org-logo.png $(1)/usr/share/libwebsockets-test-server/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/share/libwebsockets-test-server/libwebsockets-test-server.key.pem $(1)/usr/share/libwebsockets-test-server/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/share/libwebsockets-test-server/libwebsockets-test-server.pem $(1)/usr/share/libwebsockets-test-server/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/share/libwebsockets-test-server/test.html $(1)/usr/share/libwebsockets-test-server/
endef

$(eval $(call BuildPackage,libwebsockets))
$(eval $(call BuildPackage,libwebsockets-examples))

