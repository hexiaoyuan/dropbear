#
# ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk
#


LOCAL_PATH:= $(call my-dir)

#a_local_cflags := -O3 -Wall -DDROPBEAR_SERVER -DDROPBEAR_CLIENT -DPROGRESS_METER
a_local_cflags := -O3 -Wall -DDROPBEAR_SERVER -DDROPBEAR_CLIENT

a_src_common=dbutil.c buffer.c \
			 dss.c bignum.c \
			 signkey.c rsa.c dbrandom.c \
			 queue.c \
			 atomicio.c compat.c fake-rfc2553.c \
			 ltc_prng.c ecc.c ecdsa.c crypto_desc.c \
			 gensignkey.c gendss.c genrsa.c

a_src_srv=svr-kex.c svr-auth.c sshpty.c \
		  svr-authpasswd.c svr-authpubkey.c svr-authpubkeyoptions.c svr-session.c svr-service.c \
		  svr-chansession.c svr-runopts.c svr-agentfwd.c svr-main.c svr-x11fwd.c\
		  svr-tcpfwd.c svr-authpam.c

a_src_cli=cli-main.c cli-auth.c cli-authpasswd.c cli-kex.c \
		  cli-session.c cli-runopts.c cli-chansession.c \
		  cli-authpubkey.c cli-tcpfwd.c cli-channel.c cli-authinteract.c \
		  cli-agentfwd.c list.c

a_src_clisvr=common-session.c packet.c common-algo.c common-kex.c \
			 common-channel.c common-chansession.c termcodes.c loginrec.c \
			 tcp-accept.c listener.c process-packet.c \
			 common-runopts.c circbuffer.c curve25519-donna.c

a_src_key=dropbearkey.c

a_src_convert=dropbearconvert.c keyimport.c

a_src_scp=scp.c progressmeter.c atomicio.c scpmisc.c compat.c

a_headers=options.h dbutil.h session.h packet.h algo.h ssh.h buffer.h kex.h \
		  dss.h bignum.h signkey.h rsa.h dbrandom.h service.h auth.h \
		  debug.h channel.h chansession.h config.h queue.h sshpty.h \
		  termcodes.h gendss.h genrsa.h runopts.h includes.h \
		  loginrec.h atomicio.h x11fwd.h agentfwd.h tcpfwd.h compat.h \
		  listener.h fake-rfc2553.h ecc.h ecdsa.h

#dropbearobjs=$(a_src_common) $(a_src_clisvr) $(a_src_srv)
#dbclientobjs=$(a_src_common) $(a_src_clisvr) $(a_src_cli)
#dropbearkeyobjs=$(a_src_common) $(a_src_key)
#dropbearconvertobjs=$(a_src_common) $(a_src_convert)

#### scp
include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(a_src_scp)
LOCAL_STATIC_LIBRARIES := libtommath libtomcrypt
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := scp
LOCAL_C_INCLUDES += $(LOCAL_PATH) $(LOCAL_PATH)/libtommath $(LOCAL_PATH)/libtomcrypt/src/headers
LOCAL_CFLAGS += $(a_local_cflags)
include $(BUILD_EXECUTABLE)

### dropbear
include $(CLEAR_VARS)
LOCAL_SRC_FILES:= $(a_src_common) $(a_src_clisvr) $(a_src_srv)
LOCAL_SHARED_LIBRARIES := libc
LOCAL_STATIC_LIBRARIES := libtommath libtomcrypt
LOCAL_MODULE_TAGS := optional
LOCAL_LDLIBS := -lz
LOCAL_MODULE := dropbear
LOCAL_C_INCLUDES += $(LOCAL_PATH) $(LOCAL_PATH)/libtommath $(LOCAL_PATH)/libtomcrypt/src/headers
LOCAL_CFLAGS += $(a_local_cflags)
include $(BUILD_EXECUTABLE)

#### dbclient
#include $(CLEAR_VARS)
#LOCAL_SRC_FILES:= $(a_src_common) $(a_src_clisvr) $(a_src_cli)
#LOCAL_SHARED_LIBRARIES := libc
#LOCAL_STATIC_LIBRARIES := libtommath libtomcrypt
#LOCAL_MODULE_TAGS := optional
#LOCAL_LDLIBS := -lz
#LOCAL_MODULE := dbclient
#LOCAL_C_INCLUDES += $(LOCAL_PATH) $(LOCAL_PATH)/libtommath $(LOCAL_PATH)/libtomcrypt/src/headers
#LOCAL_CFLAGS += $(a_local_cflags)
#include $(BUILD_EXECUTABLE)
#
#### dropbearkey
#include $(CLEAR_VARS)
#LOCAL_SRC_FILES:= $(a_src_common) $(a_src_key)
#LOCAL_SHARED_LIBRARIES := libc
#LOCAL_STATIC_LIBRARIES := libtommath libtomcrypt
#LOCAL_MODULE_TAGS := optional
#LOCAL_LDLIBS := -lz
#LOCAL_MODULE := dropbearkey
#LOCAL_C_INCLUDES += $(LOCAL_PATH) $(LOCAL_PATH)/libtommath $(LOCAL_PATH)/libtomcrypt/src/headers
#LOCAL_CFLAGS += $(a_local_cflags)
#include $(BUILD_EXECUTABLE)
#
#### dropbearconvert
#include $(CLEAR_VARS)
#LOCAL_SRC_FILES:= $(a_src_common) $(a_src_convert)
#LOCAL_SHARED_LIBRARIES := libc
#LOCAL_STATIC_LIBRARIES := libtommath libtomcrypt
#LOCAL_MODULE_TAGS := optional
#LOCAL_LDLIBS := -lz
#LOCAL_MODULE := dropbearconvert
#LOCAL_C_INCLUDES += $(LOCAL_PATH) $(LOCAL_PATH)/libtommath $(LOCAL_PATH)/libtomcrypt/src/headers
#LOCAL_CFLAGS += $(a_local_cflags)
#include $(BUILD_EXECUTABLE)

###
include $(call all-makefiles-under,$(LOCAL_PATH))
