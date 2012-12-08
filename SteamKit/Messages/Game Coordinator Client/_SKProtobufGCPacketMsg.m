//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKProtobufGCPacketMsg.h"
#import "SteamLanguageInternal.h"

@implementation _SKProtobufGCPacketMsg
{
    uint32_t _messageType;
    NSData * _data;
    uint64_t _targetJobID;
    uint64_t _sourceJobID;
}

@synthesize data = _data;
@synthesize messageType = _messageType;
@synthesize targetJobID = _targetJobID;
@synthesize sourceJobID = _sourceJobID;

- (BOOL) isProtobuf { return true; }

- (id) initWithEGCMsg:(uint32_t)msg data:(NSData *)data
{
    self = [super init];
    if (self)
    {
        _messageType = msg;
        _data = data;
        
        _SKMsgGCHdrProtoBuf * protobufHeader = [[_SKMsgGCHdrProtoBuf alloc] init];
        CRDataReader * reader = [[CRDataReader alloc] initWithData:data];
        [protobufHeader deserializeWithReader:reader];
        
        _targetJobID = protobufHeader.proto.jobidTarget;
        _sourceJobID = protobufHeader.proto.jobidSource;
    }
    return self;
}

@end
