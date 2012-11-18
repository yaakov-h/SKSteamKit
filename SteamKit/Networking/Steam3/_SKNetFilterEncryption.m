//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKNetFilterEncryption.h"
#import <CRBoilerplate/CRBoilerplate.h>
#import "NSData+AES.h"

@implementation _SKNetFilterEncryption
{
    NSData * _sessionKey;
}

- (id) initWithSessionKey:(NSData *)sessionKey
{
    self = [super init];
    if (self)
    {
        _sessionKey = [sessionKey copy];
    }
    return self;
}

- (NSData *) dataByDecryptingIncomingData:(NSData *)data
{
    return [data sk_symmetricDecryptWithSteamSessionKey:_sessionKey];
}

- (NSData *) dataByEncryptingOutgoingData:(NSData *)data
{
    return [data sk_symmetricEncryptWithSteamSessionKey:_sessionKey];
}


@end
