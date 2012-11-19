//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "NSData+RSA.h"
#import <OpenSSL/rsa.h>

@implementation NSData (RSA)

- (NSData *) sk_asymmetricEncryptWithSteamUniversePublicKey:(NSData *)key {
	static const NSUInteger keySize = 1024;
	NSData * modulus = [key subdataWithRange:NSMakeRange(29, keySize / 8)];
	NSData * exponent = [key subdataWithRange:NSMakeRange(29 + modulus.length + 2, 1)];
	
	return [self sk_asymmetricEncryptWithModulus:modulus exponent:exponent];
}

- (NSData *) sk_asymmetricEncryptWithModulus:(NSData *)modulus exponent:(NSData *)exponent {
    
	RSA * key;
	
	unsigned char *_modulus;
	unsigned char *exp;
	
	_modulus = (unsigned char *) [modulus bytes];
	exp = (unsigned char *) [exponent bytes];
	
	unsigned char * plain = (unsigned char *) [self bytes];
	size_t plain_length = [self length];
	
	BIGNUM * bn_mod = NULL;
	BIGNUM * bn_exp = NULL;
	
	bn_mod = BN_bin2bn(_modulus, 128, NULL); // Convert both values to BIGNUM
	bn_exp = BN_bin2bn(exp, 1, NULL);
	
	key = RSA_new(); // Create a new RSA key
	key->n = bn_mod; // Assign in the values
	key->e = bn_exp;
	key->d = NULL;
	key->p = NULL;
	key->q = NULL;
	
	int maxSize = RSA_size(key); // Find the length of the cipher text
	
	unsigned char * cipher = (unsigned char *)malloc(sizeof(unsigned char) * maxSize);
	memset(cipher, 0, maxSize);
	RSA_public_encrypt(plain_length, plain, cipher, key,RSA_PKCS1_OAEP_PADDING); // Encrypt plaintext
	
	NSData * retval = [NSData dataWithBytes:cipher length:maxSize];
	free(cipher);
	return retval;
}

@end
