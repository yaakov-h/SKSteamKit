//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKClientMsgProtobuf.h"
#import "SteamLanguageInternal.h"
#import "_SKPacketMsg.h"

@implementation _SKClientMsgProtobuf

- (BOOL) isProtobuf { return true; }
- (EMsg) messageType { return [self.header msg] ; }

- (int32_t) sessionID { return self.protoHeader.clientSessionid; };
- (void) setSessionID:(int32_t)sessionID
{
    CMsgProtoBufHeader_Builder * builder = [self.protoHeader toBuilder];
    [builder setClientSessionid:sessionID];
    [self.header setProto:[builder build]];
}

- (uint64_t) steamID { return self.protoHeader.steamid; }
- (void) setSteamID:(uint64_t)steamID
{
    CMsgProtoBufHeader_Builder * builder = [self.protoHeader toBuilder];
    [builder setSteamid:steamID];
    [self.header setProto:[builder build]];
}

- (uint64_t) targetJobID { return self.protoHeader.jobidTarget; }
- (void) setTargetJobID:(uint64_t)targetJobID
{
    CMsgProtoBufHeader_Builder * builder = [self.protoHeader toBuilder];
    [builder setJobidTarget:targetJobID];
    [self.header setProto:[builder build]];
}

- (uint64_t) sourceJobID { return self.protoHeader.jobidSource; }
- (void) setSourceJobID:(uint64_t)sourceJobID
{
    CMsgProtoBufHeader_Builder * builder = [self.protoHeader toBuilder];
    [builder setJobidSource:sourceJobID];
    [self.header setProto:[builder build]];
}

- (CMsgProtoBufHeader *) protoHeader { return [(_SKMsgHdrProtoBuf *)self.header proto]; }

- (id) initWithBodyClass:(Class)bodyClass messageType:(EMsg)msg
{
    self = [super initWithHeaderClass:[_SKMsgHdrProtoBuf class]];
    if (self)
    {
        _body = [[bodyClass alloc] init];
        [self.header setProto:[[[CMsgProtoBufHeader_Builder alloc] init] build]];
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
    if (!packetMsg.isProtobuf)
    {
		[NSException raise:@"Incorrect message processor" format:@"%@ used for non-protobuf message", NSStringFromClass([self class])];
    }
    
    self = [super initWithHeaderClass:[_SKMsgHdrProtoBuf class]];
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
    
    [self.header setHeaderLength:[self.protoHeader serializedSize]];
    
    [self.header serialize:data];
    [data appendData:[(PBAbstractMessage *)self.body data]];
    [data appendData:self.payload];
    
    return [data copy];
}

- (void) deserialize:(NSData *)data
{
    CRDataReader * reader = [[CRDataReader alloc] initWithData:data];
    [self.header deserializeWithReader:reader];
    
    NSInputStream * stream = [NSInputStream inputStreamWithData:[reader remainingData]];
    _body = [[self.body class] parseFromInputStream:stream];
    
    NSMutableData * payload = [[NSMutableData alloc] init];
    while ([stream hasBytesAvailable])
    {
        uint8_t buf[128];
        NSUInteger bytesRead = [stream read:buf maxLength:128];
        [payload appendBytes:buf length:bytesRead];
    }
    
    self.payload = [payload mutableCopy];
}

@end
