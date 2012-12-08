//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKClientGCMsg.h"
#import "SteamLanguageInternal.h"
#import "_SKGCPacketMsg.h"

@implementation _SKClientGCMsg

- (BOOL) isProtobuf { return false; }
- (uint32_t) messageType { return [self.header msg] ; }

- (uint64_t) targetJobID { return self.extendedHeader.targetJobID; }
- (void) setTargetJobID:(uint64_t)targetJobID
{
    self.gcHeader.targetJobID = targetJobID;
}

- (uint64_t) sourceJobID { return self.extendedHeader.sourceJobID; }
- (void) setSourceJobID:(uint64_t)sourceJobID
{
    self.gcHeader.sourceJobID = sourceJobID;
}

- (_SKMsgGCHdr *) gcHeader { return (_SKMsgGCHdr *)self.header; }

- (id) initWithBodyClass:(Class)bodyClass messageType:(uint32_t)msg
{
    self = [super initWithHeaderClass:[_SKMsgGCHdr class]];
    if (self)
    {
        _body = [[bodyClass alloc] init];
        [self.header setMsg:msg];
    }
    return self;
}

- (id) initWithBodyClass:(Class)bodyClass messageType:(uint32_t)msg sourceJobMessage:(_SKGCMsgBase *)sourceJobMessage
{
    self = [self initWithBodyClass:bodyClass messageType:msg];
    if (self)
    {
        self.targetJobID = sourceJobMessage.sourceJobID;
    }
    return self;
}

- (id) initWithBodyClass:(Class)bodyClass packetMessage:(_SKGCPacketMsg *)packetMsg
{
    if (packetMsg.isProtobuf)
    {
		[NSException raise:@"Incorrect message processor" format:@"%@ used for protobuf message", NSStringFromClass([self class])];
    }
    
    self = [super initWithHeaderClass:[_SKMsgGCHdr class]];
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
