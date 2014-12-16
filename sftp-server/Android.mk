

APP_PLATFORM := android-16
TARGET_PIE := true
NDK_APP_PIE := true

a_local_cflags := -O3 -Wall -fPIE
a_local_ldflags := -O3 -Wall -pie -fPIE
a_local_src := \
	sftp-server.c sftp-common.c sftp-server-main.c \
	addrmatch.c bufaux.c buffer.c compat.c log.c \
	openbsd-compat/bsd-misc.c openbsd-compat/bsd-statvfs.c \
	openbsd-compat/fmt_scaled.c openbsd-compat/getopt.c openbsd-compat/port-tun.c \
	openbsd-compat/pwcache.c \
	openbsd-compat/strmode.c openbsd-compat/strtonum.c openbsd-compat/vis.c \
	match.c misc.c \
	xmalloc.c

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
LOCAL_SRC_FILES:= $(a_local_src)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := sftp-server
LOCAL_CFLAGS := $(a_local_cflags)
LOCAL_LDFLAGS := $(a_local_ldflags)
include $(BUILD_EXECUTABLE)

