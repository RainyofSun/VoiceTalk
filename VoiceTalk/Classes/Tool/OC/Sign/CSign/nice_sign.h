#ifndef __NICE_SIGN_H__
#define __NICE_SIGN_H__

/* from nice_sign.c */
const char *nice_sign(const char *source_str, const char *dev_str, const char *salt_str, const unsigned int sign_ver);
const char *nice_sign_v3(const char *source_str, const char *dev_str, const char *salt_str);

#endif

