ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest
#THEOS_PACKAGE_DIR_NAME = debs

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = @@PROJECTNAME@@
@@PROJECTNAME@@_FILES = Tweak.xm ModMenu.mm Hack.mm Hook.mm SliderHook.mm TextfieldHook.mm InfoView.mm
@@PROJECTNAME@@_FRAMEWORKS = UIKit MessageUI Social QuartzCore CoreGraphics Foundation AVFoundation Accelerate GLKit SystemConfiguration
@@PROJECTNAME@@_LDFLAGS += -Wl,-segalign,4000,-lstdc++
@@PROJECTNAME@@_CFLAGS ?= -DALWAYS_INLINE=1 -Os -std=c++11 -w -s

include $(THEOS_MAKE_PATH)/tweak.mk

@@KILL_RULE@@
SUBPROJECTS += @@PROJECTNAME@@ @@PROJECTNAME@@
include $(THEOS_MAKE_PATH)/aggregate.mk
