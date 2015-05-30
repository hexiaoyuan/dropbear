#
# ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk
#


APP_PLATFORM := android-16
TARGET_PIE := true
NDK_APP_PIE := true

a_local_cflags := -O3 -Wall -fPIE -DDROPBEAR_SERVER -DDROPBEAR_CLIENT 
#a_local_cflags += -DDEBUG_TRACE
a_local_cflags += -DDROPBEAR_DEFPORT='"22022"'
a_local_cflags += -DSFTPSERVER_PATH='"/data/data/me.xyhe.sshd4android/dropbear/sftp-server"'
a_local_cflags += -DDROPBEAR_PATH_SSH_PROGRAM='"/data/data/me.xyhe.sshd4android/dropbear/scp"'
a_local_cflags += -D_DEFAULT_AUTH_PW_DIR='"/data/data/me.xyhe.sshd4android/home"'	# default: /data/local/tmp
#a_local_cflags += -D_DEFAULT_AUTH_PW_SHELL='"/data/data/me.xyhe.sshd4android/dropbear/busybox"'	# default: /system/bin/sh

a_local_ldflags := -O3 -Wall -pie -fPIE

a_src_common=dbutil.c buffer.c \
			 dss.c bignum.c \
			 signkey.c rsa.c dbrandom.c \
			 queue.c \
			 atomicio.c compat.c fake-rfc2553.c \
			 ltc_prng.c ecc.c ecdsa.c crypto_desc.c \
			 gensignkey.c gendss.c genrsa.c list.c netio.c

a_src_clisvr=common-session.c packet.c common-algo.c common-kex.c \
			 common-channel.c common-chansession.c termcodes.c loginrec.c \
			 tcp-accept.c listener.c process-packet.c \
			 common-runopts.c circbuffer.c curve25519-donna.c netbsd_getpass.c

a_src_cli=cli-main.c cli-auth.c cli-authpasswd.c cli-kex.c \
		  cli-session.c cli-runopts.c cli-chansession.c \
		  cli-authpubkey.c cli-tcpfwd.c cli-channel.c cli-authinteract.c \
		  cli-agentfwd.c

a_src_srv=svr-kex.c svr-auth.c sshpty.c \
		  svr-authpasswd.c svr-authpubkey.c svr-authpubkeyoptions.c svr-session.c svr-service.c \
		  svr-chansession.c svr-runopts.c svr-agentfwd.c svr-main.c svr-x11fwd.c \
		  svr-tcpfwd.c svr-authpam.c freebsd_crypt.c

a_src_key=dropbearkey.c

a_src_convert=dropbearconvert.c keyimport.c

a_src_scp=scp.c progressmeter.c atomicio.c scpmisc.c compat.c


### ssh <-- we will build openssh version instead
LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := ssh
LOCAL_SRC_FILES:= $(a_src_common) $(a_src_clisvr) $(a_src_cli)
LOCAL_CFLAGS += $(a_local_cflags)
LOCAL_LDFLAGS += $(a_local_ldflags)
LOCAL_C_INCLUDES += $(LOCAL_PATH) $(LOCAL_PATH)/libtommath $(LOCAL_PATH)/libtomcrypt/src/headers
LOCAL_STATIC_LIBRARIES := libtommath libtomcrypt
LOCAL_LDLIBS := -lz
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

#### scp
include $(CLEAR_VARS)
LOCAL_MODULE := scp
LOCAL_SRC_FILES:= $(a_src_scp)
LOCAL_CFLAGS += $(a_local_cflags) -DPROGRESS_METER
LOCAL_LDFLAGS += $(a_local_ldflags)
LOCAL_C_INCLUDES += $(LOCAL_PATH) $(LOCAL_PATH)/libtommath $(LOCAL_PATH)/libtomcrypt/src/headers
LOCAL_STATIC_LIBRARIES := libtommath libtomcrypt
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)


### dropbear
include $(CLEAR_VARS)
LOCAL_MODULE := dropbear
LOCAL_SRC_FILES:= $(a_src_common) $(a_src_clisvr) $(a_src_srv)
LOCAL_CFLAGS += $(a_local_cflags)
LOCAL_LDFLAGS += $(a_local_ldflags)
LOCAL_C_INCLUDES += $(LOCAL_PATH) $(LOCAL_PATH)/libtommath $(LOCAL_PATH)/libtomcrypt/src/headers
LOCAL_STATIC_LIBRARIES := libtommath libtomcrypt
LOCAL_LDLIBS := -lz
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

### dropbearkey
include $(CLEAR_VARS)
LOCAL_MODULE := dropbearkey
LOCAL_SRC_FILES:= $(a_src_common) $(a_src_key)
LOCAL_CFLAGS += $(a_local_cflags)
LOCAL_LDFLAGS += $(a_local_ldflags)
LOCAL_C_INCLUDES += $(LOCAL_PATH) $(LOCAL_PATH)/libtommath $(LOCAL_PATH)/libtomcrypt/src/headers
LOCAL_STATIC_LIBRARIES := libtommath libtomcrypt
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)


### dropbearconvert
include $(CLEAR_VARS)
LOCAL_MODULE := dropbearconvert
LOCAL_SRC_FILES:= $(a_src_common) $(a_src_convert)
LOCAL_CFLAGS += $(a_local_cflags)
LOCAL_LDFLAGS += $(a_local_ldflags)
LOCAL_C_INCLUDES += $(LOCAL_PATH) $(LOCAL_PATH)/libtommath $(LOCAL_PATH)/libtomcrypt/src/headers
LOCAL_STATIC_LIBRARIES := libtommath libtomcrypt
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)


include $(call all-makefiles-under,$(LOCAL_PATH))
