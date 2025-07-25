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

AC_DEFUN([CHECK_LIBC_COMPAT], [
# Check for libc headers
AC_CHECK_HEADERS([endian.h machine/endian.h err.h readpassphrase.h])
AC_CHECK_HEADERS([netinet/ip.h], [], [],
[#include <sys/types.h>
#include <arpa/inet.h>
])
AC_HEADER_RESOLV
# Check for general libc functions
AC_CHECK_FUNCS([asprintf freezero getdelim getline memmem])
AC_CHECK_FUNCS([readpassphrase reallocarray recallocarray])
AC_CHECK_FUNCS([strcasecmp strlcat strlcpy strndup strnlen strsep strtonum])
AC_CHECK_FUNCS([timegm _mkgmtime timespecsub])
AC_CHECK_FUNCS([getopt getprogname syslog syslog_r])
AC_CACHE_CHECK([for getpagesize], ac_cv_func_getpagesize, [
	AC_LINK_IFELSE([AC_LANG_PROGRAM([[
#include <unistd.h>
		]], [[
	getpagesize();
]])],
	[ ac_cv_func_getpagesize="yes" ],
	[ ac_cv_func_getpagesize="no"
	])
])
AM_CONDITIONAL([HAVE_ASPRINTF], [test "x$ac_cv_func_asprintf" = xyes])
AM_CONDITIONAL([HAVE_FREEZERO], [test "x$ac_cv_func_freezero" = xyes])
AM_CONDITIONAL([HAVE_GETDELIM], [test "x$ac_cv_func_getdelim" = xyes])
AM_CONDITIONAL([HAVE_GETLINE], [test "x$ac_cv_func_getline" = xyes])
AM_CONDITIONAL([HAVE_GETPAGESIZE], [test "x$ac_cv_func_getpagesize" = xyes])
AM_CONDITIONAL([HAVE_GETOPT], [test "x$ac_cv_func_getopt" = xyes])
AM_CONDITIONAL([HAVE_MEMMEM], [test "x$ac_cv_func_memmem" = xyes])
AM_CONDITIONAL([HAVE_READPASSPHRASE], [test "x$ac_cv_func_readpassphrase" = xyes])
AM_CONDITIONAL([HAVE_REALLOCARRAY], [test "x$ac_cv_func_reallocarray" = xyes])
AM_CONDITIONAL([HAVE_RECALLOCARRAY], [test "x$ac_cv_func_recallocarray" = xyes])
AM_CONDITIONAL([HAVE_STRCASECMP], [test "x$ac_cv_func_strcasecmp" = xyes])
AM_CONDITIONAL([HAVE_STRLCAT], [test "x$ac_cv_func_strlcat" = xyes])
AM_CONDITIONAL([HAVE_STRLCPY], [test "x$ac_cv_func_strlcpy" = xyes])
AM_CONDITIONAL([HAVE_STRNDUP], [test "x$ac_cv_func_strndup" = xyes])
AM_CONDITIONAL([HAVE_STRNLEN], [test "x$ac_cv_func_strnlen" = xyes])
AM_CONDITIONAL([HAVE_STRSEP], [test "x$ac_cv_func_strsep" = xyes])
AM_CONDITIONAL([HAVE_STRTONUM], [test "x$ac_cv_func_strtonum" = xyes])
AM_CONDITIONAL([HAVE_GETPROGNAME], [test "x$ac_cv_func_getprogname" = xyes])
AM_CONDITIONAL([HAVE_SYSLOG], [test "x$ac_cv_func_syslog" = xyes])
AM_CONDITIONAL([HAVE_SYSLOG_R], [test "x$ac_cv_func_syslog_r" = xyes])
])

AC_DEFUN([CHECK_SYSCALL_COMPAT], [
AC_CHECK_FUNCS([accept4 pipe2 pledge poll socketpair])
AM_CONDITIONAL([HAVE_ACCEPT4], [test "x$ac_cv_func_accept4" = xyes])
AM_CONDITIONAL([HAVE_PIPE2], [test "x$ac_cv_func_pipe2" = xyes])
AM_CONDITIONAL([HAVE_PLEDGE], [test "x$ac_cv_func_pledge" = xyes])
AM_CONDITIONAL([HAVE_POLL], [test "x$ac_cv_func_poll" = xyes])
AM_CONDITIONAL([HAVE_SOCKETPAIR], [test "x$ac_cv_func_socketpair" = xyes])
])

AC_DEFUN([CHECK_B64_NTOP], [
AC_SEARCH_LIBS([b64_ntop],[resolv])
AC_SEARCH_LIBS([__b64_ntop],[resolv])
AC_CACHE_CHECK([for b64_ntop], ac_cv_have_b64_ntop_arg, [
	AC_LINK_IFELSE([AC_LANG_PROGRAM([[
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <resolv.h>
		]], [[ b64_ntop(NULL, 0, NULL, 0); ]])],
	[ ac_cv_have_b64_ntop_arg="yes" ],
	[ ac_cv_have_b64_ntop_arg="no"
	])
])
AM_CONDITIONAL([HAVE_B64_NTOP], [test "x$ac_cv_func_b64_ntop_arg" = xyes])
])

AC_DEFUN([CHECK_CRYPTO_COMPAT], [
# Check crypto-related libc functions and syscalls
AC_CHECK_FUNCS([arc4random arc4random_buf arc4random_uniform])
AC_CHECK_FUNCS([explicit_bzero getauxval])

AC_CACHE_CHECK([for getentropy], ac_cv_func_getentropy, [
	AC_LINK_IFELSE([AC_LANG_PROGRAM([[
#include <sys/types.h>
#include <unistd.h>

/*
 * Explanation:
 *
 *   - iOS <= 10.1 fails because of missing sys/random.h
 *
 *   - in macOS 10.12 getentropy is not tagged as introduced in
 *     10.12 so we cannot use it for target < 10.12
 */
#ifdef __APPLE__
#  include <AvailabilityMacros.h>
#  include <TargetConditionals.h>

# if (TARGET_OS_IPHONE || TARGET_OS_SIMULATOR)
#  include <sys/random.h> /* Not available as of iOS <= 10.1 */
# else

#  include <sys/random.h> /* Pre 10.12 systems should die here */

/* Based on: https://gitweb.torproject.org/tor.git/commit/?id=16fcbd21 */
#  ifndef MAC_OS_X_VERSION_10_12
#    define MAC_OS_X_VERSION_10_12 101200 /* Robustness */
#  endif
#  if defined(MAC_OS_X_VERSION_MIN_REQUIRED)
#    if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_12
#      error "Targeting on Mac OSX 10.11 or earlier"
#    endif
#  endif

# endif
#endif /* __APPLE__ */
		]], [[
	char buffer;
	(void)getentropy(&buffer, sizeof (buffer));
]])],
	[ ac_cv_func_getentropy="yes" ],
	[ ac_cv_func_getentropy="no"
	])
])

AC_CHECK_FUNCS([timingsafe_bcmp timingsafe_memcmp])
AM_CONDITIONAL([HAVE_ARC4RANDOM], [test "x$ac_cv_func_arc4random" = xyes])
AM_CONDITIONAL([HAVE_ARC4RANDOM_BUF], [test "x$ac_cv_func_arc4random_buf" = xyes])
AM_CONDITIONAL([HAVE_ARC4RANDOM_UNIFORM], [test "x$ac_cv_func_arc4random_uniform" = xyes])
AM_CONDITIONAL([HAVE_EXPLICIT_BZERO], [test "x$ac_cv_func_explicit_bzero" = xyes])
AM_CONDITIONAL([HAVE_GETENTROPY], [test "x$ac_cv_func_getentropy" = xyes])
AM_CONDITIONAL([HAVE_TIMINGSAFE_BCMP], [test "x$ac_cv_func_timingsafe_bcmp" = xyes])
AM_CONDITIONAL([HAVE_TIMINGSAFE_MEMCMP], [test "x$ac_cv_func_timingsafe_memcmp" = xyes])

# Override arc4random_buf implementations with known issues
AM_CONDITIONAL([HAVE_ARC4RANDOM_BUF],
	[test "x$USE_BUILTIN_ARC4RANDOM" != xyes \
	   -a "x$ac_cv_func_arc4random_buf" = xyes])

# Check for getentropy fallback dependencies
AC_CHECK_FUNCS([getauxval])
AC_SEARCH_LIBS([dl_iterate_phdr],[dl])
AC_CHECK_FUNCS([dl_iterate_phdr])

AC_SEARCH_LIBS([pthread_once],[pthread])
AC_SEARCH_LIBS([pthread_mutex_lock],[pthread])
AC_SEARCH_LIBS([clock_gettime],[rt posix4])
AC_CHECK_FUNCS([clock_gettime])
AM_CONDITIONAL([HAVE_CLOCK_GETTIME], [test "x$ac_cv_func_clock_gettime" = xyes])
])

AC_DEFUN([CHECK_VA_COPY], [
AC_CACHE_CHECK([whether va_copy exists], ac_cv_have_va_copy, [
	AC_LINK_IFELSE([AC_LANG_PROGRAM([[
#include <stdarg.h>
va_list x,y;
		]], [[ va_copy(x,y); ]])],
	[ ac_cv_have_va_copy="yes" ],
	[ ac_cv_have_va_copy="no"
	])
])
if test "x$ac_cv_have_va_copy" = "xyes" ; then
	AC_DEFINE([HAVE_VA_COPY], [1], [Define if va_copy exists])
fi

AC_CACHE_CHECK([whether __va_copy exists], ac_cv_have___va_copy, [
	AC_LINK_IFELSE([AC_LANG_PROGRAM([[
#include <stdarg.h>
va_list x,y;
		]], [[ __va_copy(x,y); ]])],
	[ ac_cv_have___va_copy="yes" ], [ ac_cv_have___va_copy="no"
	])
])
if test "x$ac_cv_have___va_copy" = "xyes" ; then
	AC_DEFINE([HAVE___VA_COPY], [1], [Define if __va_copy exists])
fi
])
