#
# Copyright (c) 2014 Brent Cook
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

include $(top_srcdir)/Makefile.am.common

-include $(abs_top_builddir)/crypto/libcrypto_la_objects.mk

AM_CPPFLAGS += -I$(top_srcdir)/crypto
AM_CPPFLAGS += -I$(top_srcdir)/crypto/bio

noinst_LTLIBRARIES = libbs.la

if ENABLE_LIBTLS_ONLY
noinst_LTLIBRARIES += libssl.la
else
lib_LTLIBRARIES = libssl.la
endif

noinst_DATA = remove_bs_objects

EXTRA_DIST = VERSION
EXTRA_DIST += CMakeLists.txt
EXTRA_DIST += ssl.sym
EXTRA_DIST += empty.c

CLEANFILES = libssl_la_objects.mk

EXTRA_libssl_la_DEPENDENCIES = libssl_la_objects.mk

libssl_la_objects.mk: Makefile
	@echo "libssl_la_objects= $(libssl_la_OBJECTS)" \
	  | sed 's/  */ $$\(top_builddir\)\/ssl\//g' \
	  > libssl_la_objects.mk

.PHONY: remove_bs_objects
remove_bs_objects: libssl.la
	-$(AR) dv $(abs_top_builddir)/ssl/.libs/libssl.a \
	    bs_ber.o bs_cbb.o bs_cbs.o

libssl_la_CPPFLAGS = -I$(top_srcdir)/ssl/hidden ${AM_CPPFLAGS}
libssl_la_LDFLAGS = -version-info @LIBSSL_VERSION@ -no-undefined -export-symbols $(top_srcdir)/ssl/ssl.sym
libssl_la_LIBADD = $(abs_top_builddir)/crypto/libcrypto.la $(PLATFORM_LDADD)
libssl_la_LIBADD += $(libcompat_la_objects)
libssl_la_LIBADD += $(libcompatnoopt_la_objects)
libssl_la_LIBADD += libbs.la

libbs_la_SOURCES = bs_ber.c
libbs_la_SOURCES += bs_cbb.c
libbs_la_SOURCES += bs_cbs.c
noinst_HEADERS = bytestring.h

noinst_HEADERS += hidden/ssl_namespace.h
noinst_HEADERS += hidden/openssl/srtp.h
noinst_HEADERS += hidden/openssl/tls1.h
noinst_HEADERS += hidden/openssl/ssl.h

libssl_la_SOURCES = bio_ssl.c
libssl_la_SOURCES += d1_both.c
libssl_la_SOURCES += d1_lib.c
libssl_la_SOURCES += d1_pkt.c
libssl_la_SOURCES += d1_srtp.c
libssl_la_SOURCES += pqueue.c
libssl_la_SOURCES += s3_cbc.c
libssl_la_SOURCES += s3_lib.c
libssl_la_SOURCES += ssl_asn1.c
libssl_la_SOURCES += ssl_both.c
libssl_la_SOURCES += ssl_cert.c
libssl_la_SOURCES += ssl_ciph.c
libssl_la_SOURCES += ssl_ciphers.c
libssl_la_SOURCES += ssl_clnt.c
libssl_la_SOURCES += ssl_err.c
libssl_la_SOURCES += ssl_init.c
libssl_la_SOURCES += ssl_kex.c
libssl_la_SOURCES += ssl_lib.c
libssl_la_SOURCES += ssl_methods.c
libssl_la_SOURCES += ssl_packet.c
libssl_la_SOURCES += ssl_pkt.c
libssl_la_SOURCES += ssl_rsa.c
libssl_la_SOURCES += ssl_seclevel.c
libssl_la_SOURCES += ssl_sess.c
libssl_la_SOURCES += ssl_sigalgs.c
libssl_la_SOURCES += ssl_srvr.c
libssl_la_SOURCES += ssl_stat.c
libssl_la_SOURCES += ssl_tlsext.c
libssl_la_SOURCES += ssl_transcript.c
libssl_la_SOURCES += ssl_txt.c
libssl_la_SOURCES += ssl_versions.c
libssl_la_SOURCES += t1_enc.c
libssl_la_SOURCES += t1_lib.c
libssl_la_SOURCES += tls_buffer.c
libssl_la_SOURCES += tls_content.c
libssl_la_SOURCES += tls_key_share.c
libssl_la_SOURCES += tls_lib.c
libssl_la_SOURCES += tls12_key_schedule.c
libssl_la_SOURCES += tls12_lib.c
libssl_la_SOURCES += tls12_record_layer.c
libssl_la_SOURCES += tls13_client.c
libssl_la_SOURCES += tls13_error.c
libssl_la_SOURCES += tls13_handshake.c
libssl_la_SOURCES += tls13_handshake_msg.c
libssl_la_SOURCES += tls13_key_schedule.c
libssl_la_SOURCES += tls13_legacy.c
libssl_la_SOURCES += tls13_lib.c
libssl_la_SOURCES += tls13_quic.c
libssl_la_SOURCES += tls13_record.c
libssl_la_SOURCES += tls13_record_layer.c
libssl_la_SOURCES += tls13_server.c

noinst_HEADERS += srtp.h
noinst_HEADERS += dtls_local.h
noinst_HEADERS += ssl_local.h
noinst_HEADERS += ssl_sigalgs.h
noinst_HEADERS += ssl_tlsext.h
noinst_HEADERS += tls_content.h
noinst_HEADERS += tls_internal.h
noinst_HEADERS += tls12_internal.h
noinst_HEADERS += tls13_internal.h
noinst_HEADERS += tls13_handshake.h
noinst_HEADERS += tls13_record.h

# arch
if HOST_AARCH64
libssl_la_CPPFLAGS += -I$(top_srcdir)/crypto/arch/aarch64/
endif
noinst_HEADERS += $(top_srcdir)/crypto/arch/aarch64/crypto_arch.h

if HOST_ARM
libssl_la_CPPFLAGS += -I$(top_srcdir)/crypto/arch/arm/
endif
noinst_HEADERS += $(top_srcdir)/crypto/arch/arm/crypto_arch.h

if HOST_I386
libssl_la_CPPFLAGS += -I$(top_srcdir)/crypto/arch/i386/
endif
noinst_HEADERS += $(top_srcdir)/crypto/arch/i386/crypto_arch.h

if HOST_LOONGARCH64
libssl_la_CPPFLAGS += -I$(top_srcdir)/crypto/arch/loongarch64/
endif
noinst_HEADERS += $(top_srcdir)/crypto/arch/loongarch64/crypto_arch.h

if HOST_MIPS
libssl_la_CPPFLAGS += -I$(top_srcdir)/crypto/arch/mips/
endif
noinst_HEADERS += $(top_srcdir)/crypto/arch/mips/crypto_arch.h

if HOST_MIPS64
libssl_la_CPPFLAGS += -I$(top_srcdir)/crypto/arch/mips64/
endif
noinst_HEADERS += $(top_srcdir)/crypto/arch/mips64/crypto_arch.h

if HOST_POWERPC
libssl_la_CPPFLAGS += -I$(top_srcdir)/crypto/arch/powerpc/
endif
noinst_HEADERS += $(top_srcdir)/crypto/arch/powerpc/crypto_arch.h

if HOST_POWERPC64
libssl_la_CPPFLAGS += -I$(top_srcdir)/crypto/arch/powerpc64/
endif
noinst_HEADERS += $(top_srcdir)/crypto/arch/powerpc64/crypto_arch.h

if HOST_RISCV64
libssl_la_CPPFLAGS += -I$(top_srcdir)/crypto/arch/riscv64/
endif
noinst_HEADERS += $(top_srcdir)/crypto/arch/riscv64/crypto_arch.h

if HOST_SPARC64
libssl_la_CPPFLAGS += -I$(top_srcdir)/crypto/arch/sparc64/
endif
noinst_HEADERS += $(top_srcdir)/crypto/arch/sparc64/crypto_arch.h

if HOST_X86_64
libssl_la_CPPFLAGS += -I$(top_srcdir)/crypto/arch/amd64/
endif
noinst_HEADERS += $(top_srcdir)/crypto/arch/amd64/crypto_arch.h
