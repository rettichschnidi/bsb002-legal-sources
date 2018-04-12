PKG_NAME:=protobuf
PKG_VERSION:=2.6.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/google/protobuf/releases/download/v$(PKG_VERSION)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_MD5SUM:=11aaac2d704eef8efd1867a807865d85

PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE