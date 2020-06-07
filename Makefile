include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FirefoxifyChrome

FirefoxifyChrome_FILES = Tweak.xm
FirefoxifyChrome_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
