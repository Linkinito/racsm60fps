TARGET = patch
OBJS = src/psp_plugin_runtime.o src/profiler_hook.o src/rcsm_profiler_core.o src/rcsm_format.o generated/wrapper_profiles.generated.o

INCDIR = include generated
CFLAGS = -O2 -G0 -std=c11 -Wall -Wextra -Werror -fno-strict-aliasing
CXXFLAGS = -O2 -G0 -Wall -Wextra -Werror -fno-exceptions -fno-rtti
ASFLAGS = -O2 -G0
BUILD_PRX = 1
PSP_FW_VERSION = 660
PSPSDK := $(shell psp-config --pspsdk-path)

include $(PSPSDK)/lib/build.mak
