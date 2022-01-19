#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "nice_hash.h"
#include "lib/LibMd5.h"
#include "lib/LibSha1.h"

const char *nice_md5(char *string) {
	Md5Context 		md5Context;
	MD5_HASH 		md5Hash;
	static char 	md5String[MD5_HASH_SIZE * 2 + 1] = {0};
	uint16_t 		i = 0;
	
	Md5Initialise(&md5Context);
	Md5Update(&md5Context, string, (uint32_t)strlen(string));
	Md5Finalise(&md5Context, &md5Hash);

	for (i = 0; i < sizeof(md5Hash); i++) {
		md5String[2 * i + 0] = (md5Hash.bytes[i]>>4) > 9 ? 'a'+(md5Hash.bytes[i]>>4)-10 : '0'+(md5Hash.bytes[i]>>4);
		md5String[2 * i + 1] = (md5Hash.bytes[i]&0xf) > 9 ? 'a'+(md5Hash.bytes[i]&0xf)-10 : '0'+(md5Hash.bytes[i]&0xf);
	}
	return md5String;
}

const char *nice_sha1(char *string) {
	Sha1Context 	sha1Context;
	SHA1_HASH 		sha1Hash;
	static char 	sha1String[SHA1_HASH_SIZE * 2 + 1] = {0}; 
	uint16_t 		i = 0;

	Sha1Initialise(&sha1Context);
	Sha1Update(&sha1Context, string, (uint32_t)strlen(string));
	Sha1Finalise(&sha1Context, &sha1Hash);

	for (i = 0; i < sizeof(sha1Hash); i++) {
		sha1String[2 * i + 0] = (sha1Hash.bytes[i]>>4) > 9 ? 'a'+(sha1Hash.bytes[i]>>4)-10 : '0'+(sha1Hash.bytes[i]>>4);
		sha1String[2 * i + 1] = (sha1Hash.bytes[i]&0xf) > 9 ? 'a'+(sha1Hash.bytes[i]&0xf)-10 : '0'+(sha1Hash.bytes[i]&0xf);
	}
	return sha1String;
}
