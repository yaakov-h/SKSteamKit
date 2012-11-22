//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKClientMsg.h"
#import "SteamLanguageInternal.h"
#import "_SKPacketMsg.h"

@implementation _SKClientMsg

- (BOOL) isProtobuf { return false; }
- (EMsg) messageType { return [self.header msg] ; }

- (int32_t) sessionID { return self.extendedHeader.sessionID; };
- (void) setSessionID:(int32_t)sessionID
{
    self.extendedHeader.sessionID = sessionID;
}

- (uint64_t) steamID { return self.extendedHeader.steamID; }
- (void) setSteamID:(uint64_t)steamID
{
    self.extendedHeader.steamID = steamID;
}

- (uint64_t) targetJobID { return self.extendedHeader.targetJobID; }
- (void) setTargetJobID:(uint64_t)targetJobID
{
    self.extendedHeader.targetJobID = targetJobID;
}

- (uint64_t) sourceJobID { return self.extendedHeader.sourceJobID; }
- (void) setSourceJobID:(uint64_t)sourceJobID
{
    self.extendedHeader.sourceJobID = sourceJobID;
}

- (_SKExtendedClientMsgHdr *) extendedHeader { return (_SKExtendedClientMsgHdr *)self.header; }

- (id) initWithBodyClass:(Class)bodyClass messageType:(EMsg)msg
{
    self = [super initWithHeaderClass:[_SKExtendedClientMsgHdr class]];
    if (self)
    {
        _body = [[bodyClass alloc] init];
        [self.header setMsg:msg];
    }
    return self;
}

- (id) initWithBodyClass:(Class)bodyClass messageType:(EMsg)msg sourceJobMessage:(_SKMsgBase *)sourceJobMessage
{
    self = [self initWithBodyClass:bodyClass messageType:msg];
    if (self)
    {
        self.targetJobID = sourceJobMessage.sourceJobID;
    }
    return self;
}

- (id) initWithBodyClass:(Class)bodyClass packetMessage:(_SKPacketMsg *)packetMsg
{
    if (packetMsg.isProtobuf)
    {
		[NSException raise:@"Incorrect message processor" format:@"%@ used for protobuf message", NSStringFromClass([self class])];
    }
    
    self = [super initWithHeaderClass:[_SKExtendedClientMsgHdr class]];
    if (self)
    {
        _body = [[bodyClass alloc] init];
        [self deserialize:packetMsg.data];
    }
    return self;
}

- (NSData *) serialize
{
    NSMutableData * data = [[NSMutableData alloc] init];
    
    [self.header serialize:data];
	[self.body serialize:data];
    [data appendData:self.payload];
    
    return [data copy];
}

- (void) deserialize:(NSData *)data
{
    CRDataReader * reader = [[CRDataReader alloc] initWithData:data];
    [self.header deserializeWithReader:reader];
    [self.body deserializeWithReader:reader];
	self.payload = [[reader remainingData] mutableCopy];
}

@end
