//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

- (NSData *) sk_symmetricDecryptWithSteamSessionKey:(NSData *)sessionKey;
- (NSData *) sk_symmetricEncryptWithSteamSessionKey:(NSData *)sessionKey;

@end
