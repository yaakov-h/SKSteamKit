//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKMsg.h"
#import "SteamLanguageInternal.h"

@implementation _SKMsg

- (BOOL) isProtobuf { return false; }
- (EMsg) messageType { return self.internalHeader.msg; }

@synthesize sessionID = _sessionID;
@synthesize steamID = _steamID;
@synthesize targetJobID = _targetJobID;
@synthesize sourceJobID = _sourceJobID;
@synthesize body = _body;

- (_SKMsgHdr *) internalHeader { return self.header; }


- (id) initWithBodyClass:(Class)bodyClass
{
    self = [super initWithHeaderClass:[_SKMsgHdr class]];
    if (self)
    {
        _body = [[bodyClass alloc] init];
        self.internalHeader.msg = [_body eMsg];
    }
    return self;
}

- (id) initWithBodyClass:(Class)bodyClass sourceJobMessage:(_SKMsgBase *)sourceJobMsg
{
    self = [self initWithBodyClass:bodyClass];
    if (self)
    {
        self.internalHeader.targetJobID = sourceJobMsg.sourceJobID;
    }
    return self;
}

- (id) initWithBodyClass:(Class)bodyClass data:(NSData *)data
{
    self  = [self initWithBodyClass:bodyClass];
    if (self)
    {
        [self deserialize:data];
    }
    return self;
}

- (void) deserialize:(NSData *)data
{
    CRDataReader * reader = [[CRDataReader alloc] initWithData:data];
    [self.internalHeader deserializeWithReader:reader];
    [self.body deserializeWithReader:reader];
    self.payload = [[reader remainingData] mutableCopy];
}

- (NSData *) serialize
{
    NSMutableData * data = [[NSMutableData alloc] init];
    [self.internalHeader serialize:data];
    [self.body serialize:data];
    [data appendData:self.payload];
    
    return [data copy];
}

@end
