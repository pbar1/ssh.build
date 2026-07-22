#ifndef SSH_BUILD_LIBSSH2_CONFIG_H
#define SSH_BUILD_LIBSSH2_CONFIG_H

#define HAVE_ARPA_INET_H 1
#define HAVE_DLFCN_H 1
#define HAVE_ERRNO_H 1
#define HAVE_FCNTL_H 1
#define HAVE_GETTIMEOFDAY 1
#define HAVE_INTTYPES_H 1
#define HAVE_NETINET_IN_H 1
#define HAVE_O_NONBLOCK 1
#define HAVE_POLL 1
#define HAVE_SELECT 1
#define HAVE_SNPRINTF 1
#define HAVE_STDINT_H 1
#define HAVE_STDIO_H 1
#define HAVE_STDLIB_H 1
#define HAVE_STRINGS_H 1
#define HAVE_STRING_H 1
#define HAVE_STRTOLL 1
#define HAVE_SYS_IOCTL_H 1
#define HAVE_SYS_SELECT_H 1
#define HAVE_SYS_SOCKET_H 1
#define HAVE_SYS_STAT_H 1
#define HAVE_SYS_TIME_H 1
#define HAVE_SYS_TYPES_H 1
#define HAVE_SYS_UIO_H 1
#define HAVE_SYS_UN_H 1
#define HAVE_UNISTD_H 1

#define LIBSSH2_API
#define LIBSSH2_HAVE_ZLIB 1
#define LIBSSH2_OPENSSL 1

#define PACKAGE "libssh2"
#define PACKAGE_BUGREPORT "libssh2-devel@cool.haxx.se"
#define PACKAGE_NAME "libssh2"
#define PACKAGE_STRING "libssh2 1.11.1"
#define PACKAGE_TARNAME "libssh2"
#define PACKAGE_URL "https://libssh2.org/"
#define PACKAGE_VERSION "1.11.1"
#define STDC_HEADERS 1
#define VERSION "1.11.1"

#if defined(__linux__)
#define _FILE_OFFSET_BITS 64
#endif

#endif
