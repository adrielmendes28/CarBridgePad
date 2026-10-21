TARGET := iphone:clang:latest:15.0
ARCHS = arm64
# rootless (palera1n/Dopamine) por padrão; para rootful: make package THEOS_PACKAGE_SCHEME=
THEOS_PACKAGE_SCHEME ?= rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CarBridgePad
CarBridgePad_FILES = Tweak.x
CarBridgePad_CFLAGS = -fobjc-arc -Wno-unused-function
CarBridgePad_FRAMEWORKS = UIKit GameController

include $(THEOS_MAKE_PATH)/tweak.mk
