//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@interface _SKNetFilterEncryption : NSObject

- (id) initWithSessionKey:(NSData *)sessionKey;

- (NSData *) dataByDecryptingIncomingData:(NSData *)data;
- (NSData *) dataByEncryptingOutgoingData:(NSData *)data;

@end
