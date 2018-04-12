define printInColor
	echo -n "\033[$(1)m$(2)\033[0m\n"
endef

RED=31
YELLOW=33
STEP_INFO_COLOR=$(RED)

MKDIR=mkdir
PRODUCT_MAKE_DIR=bridge/build/bsb002
BUILD_DIR=build_dir/product
BUILD_LOG_DIR=$(BUILD_DIR)/build-logs
RELEASE_DIR=release/product
RELEASE_FACTORY_DIR=$(RELEASE_DIR)/factory
QSDK_DIR=$(abspath qsdk)
QSDK_SCRIPTS_DIR=$(QSDK_DIR)/scripts
QSDK_PLATFORM=ar71xx
QSDK_CONFIG_DEST=$(QSDK_DIR)/.config
QSDK_BIN_DIR=$(QSDK_DIR)/bin/$(QSDK_PLATFORM)
QSDK_MIPS_BUILD_DIR=$(QSDK_BUILD_DIR)/target-mips_*_uClibc-*
QSDK_CONFIG_FILE=bridge/build/bsb002/configs/qsdk.product.config
STATE_DIR=$(QSDK_DIR)/build_dir
TOP_BUILD_DIR=$(PRODUCT_MAKE_DIR)/build_dir
ASSEMBLED_FEEDS_CONF=$(TOP_BUILD_DIR)/feeds.conf
QSDK_FEEDS_TOOL=$(QSDK_SCRIPTS_DIR)/feeds -F $(abspath $(ASSEMBLED_FEEDS_CONF))

BIN_SOURCE_bsb002_uboot=$(QSDK_BIN_DIR)/openwrt-$(QSDK_PLATFORM)-bsb002-qca-legacy-uboot.bin
BIN_SOURCE_bsb002_art=./images/bsb002/art.bin
BIN_SOURCE_kernel=$(QSDK_BIN_DIR)/openwrt-$(QSDK_PLATFORM)-generic-uImage-lzma.bin
BIN_SOURCE_root=$(QSDK_BIN_DIR)/openwrt-$(QSDK_PLATFORM)-generic-bsb002-root-squashfs.ubi
BIN_SOURCE_overlay=$(QSDK_BIN_DIR)/openwrt-$(QSDK_PLATFORM)-generic-bsb002-overlay-jffs2.ubi

define stepinfo
	@$(call printInColor,$(STEP_INFO_COLOR),Making $@)
endef

define done
	@$(MKDIR) -p $(STATE_DIR)
	@touch $(STATE_DIR)/$@
	@$(call printInColor,$(STEP_INFO_COLOR),Done: $@)
endef

ifeq "$(shell $(MKDIR) -p $(BUILD_LOG_DIR) && echo $(BUILD_LOG_DIR))" ""
$(error mkdir $(BUILD_LOG_DIR))
endif

ifneq "$(V)" "s"
CURRENT_LOG_FILE=$(BUILD_LOG_DIR)/$(subst /,_,$@)
quietUnlessErrorsOrVerbose=>$(CURRENT_LOG_FILE) 2>&1 || (cat $(CURRENT_LOG_FILE); exit 1)
endif

ifneq "$(V)" "s"
define dumpBuildLogIfError
|| ( \
$(call printInColor,$(YELLOW),\
\n============================================================================\
\nLast build log file:\
\n  $(QSDK_LAST_WRITTEN_LOG_FILE)\
\n----------------------------------------------------------------------------\
); cat $(QSDK_LAST_WRITTEN_LOG_FILE); $(call printInColor,$(YELLOW),\
\n============================================================================\
\n\
); exit 1 )
endef
endif

.PHONY : all
all: factoryImages

.PHONY : factoryImages
factoryImages: qsdk.compile $(RELEASE_FACTORY_DIR)/bsb002
	$(call stepinfo)

.SECONDEXPANSION:
.PHONY : $(RELEASE_FACTORY_DIR)/bsb002
$(RELEASE_FACTORY_DIR)/bsb002: $$@/$$(notdir $$@)_uboot.bin $$@/kernel.bin $$@/root.bin $$@/overlay.bin
	$(call stepinfo)

%.bin: qsdk.compile
	$(call stepinfo)
	@$(MKDIR) -p $(dir $@)
	@cp $(BIN_SOURCE_$(notdir $*)) $@

define syncQsdkConfig
	@$(call printInColor,$(STEP_INFO_COLOR),Using $(QSDK_CONFIG_FILE))
	@cp -a $(QSDK_CONFIG_FILE) $(QSDK_CONFIG_DEST)
	@$(MAKE) -C $(QSDK_DIR) defconfig $(call quietUnlessErrorsOrVerbose)
endef

define qsdkMake
	$(call syncQsdkConfig)
	@$(call printInColor,$(STEP_INFO_COLOR),Within $(QSDK_DIR): make $(1))
	$(2)@$(MAKE) --no-print-directory -C $(QSDK_DIR) $(1) 
endef

.PHONY : qsdk.compile
qsdk.compile: qsdk.feeds-updated qsdk/world
	$(call stepinfo)

qsdk.feeds-updated: $(QSDK_CONFIG_FILE)
	$(call stepinfo)
	@(cd $(QSDK_DIR) && $(QSDK_FEEDS_TOOL) clean -a) $(call quietUnlessErrorsOrVerbose)
	@(cd $(QSDK_DIR) && $(QSDK_FEEDS_TOOL) update -a) $(call quietUnlessErrorsOrVerbose)
	@(cd $(QSDK_DIR) && $(QSDK_FEEDS_TOOL) install -a -f) $(call quietUnlessErrorsOrVerbose)
	$(call done)

.PHONY : qsdk/% 
qsdk/%: qsdk.feeds-updated
	$(call stepinfo)
	$(call qsdkMake,$*) $(dumpBuildLogIfError)

.PHONY : qsdk.%/purge 
qsdk.%/purge:
	$(call stepinfo)
	@rm -f $(STATE_DIR)/qsdk.$*
	@echo step.$* purged

.PHONY : qsdk.%/force
qsdk.%/force:
	$(call stepinfo)
	@$(MAKE) qsdk.$*

.PHONY : print-%
print-%:
	@echo $*=$($*)
