//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "NSData+AES.h"
#import <openssl/evp.h>
#import <openssl/aes.h>
#import <CRBoilerplate/CRBoilerplate.h>
#import <CRBoilerplate/NSMutableData+CRBoilerplate.h>
#import <vector>
#import <string>

@implementation NSData (AES)

- (NSData *) sk_symmetricDecryptWithSteamSessionKey:(NSData *)sessionKey
{
    // TODO: AES 256
    // First 16 bytes are ECB-encrypted IV using session key
    // Remaining bytes are CBC-PKCS#7 encrypted using session key and IV
    return self;
}

- (NSData *) sk_symmetricEncryptWithSteamSessionKey:(NSData *)sessionKey
{
    // TODO: AES 256
    // First 16 bytes are ECB-encrypted IV using session key
    // Remaining bytes are CBC-PKCS#7 encrypted using session key and IV
    return self;
}

@end
