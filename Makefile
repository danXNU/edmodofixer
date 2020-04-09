INSTALL_TARGET_PROCESSES = Edmodo

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EdmodoFixer

EdmodoFixer_FILES = Tweak.x
EdmodoFixer_ARCHS = arm64
EdmodoFixer_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
