include $(TOPDIR)/rules.mk

PLATFORM_TOPDIR:=$(TOPDIR)/../platform
PLATFORM_MBEDTLS_DIR:=$(PLATFORM_TOPDIR)/mbedtls

include $(PLATFORM_MBEDTLS_DIR)/config.mk

PKG_USE_MIPS16:=0
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE apache-2.0.txt

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/mbedtls/Default
  SUBMENU:=SSL
  TITLE:=Embedded SSL
  URL:=http://polarssl.org/
endef

define Package/mbedtls/Default/description
The aim of the mbed TLS project is to provide a quality, open-source
cryptographic library written in C and targeted at embedded systems.
endef

define Package/libmbedtls
$(call Package/mbedtls/Default)
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE+= (library)
  ABI_VERSION:=$(PKG_VERSION)
endef

define Package/libmbedtls/description
$(call Package/mbedtls/Default/description)
This package contains the mbed TLS library.
endef

define Package/mbedtls-progs
$(call Package/mbedtls/Default)
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libmbedtls +libpthread
  TITLE+= (programs)
endef

define Package/mbedtls-progs/description
$(call Package/mbedtls/Default/description)
This package contains the mbed TLS programs.
endef

PKG_INSTALL:=1

CMAKE_OPTIONS += \
	-DCMAKE_BUILD_TYPE:String="Release" \
	-DUSE_SHARED_MBEDTLS_LIBRARY:Bool=ON \
	-DUSE_STATIC_MBEDTLS_LIBRARY:Bool=OFF

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/mbedtls $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmbed*.so* $(1)/usr/lib/
endef

define Package/mbedtls-progs/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin/
endef

define Package/libmbedtls/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmbed*.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libmbedtls))
$(eval $(call BuildPackage,mbedtls-progs))
