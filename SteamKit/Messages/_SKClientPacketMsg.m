//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKClientPacketMsg.h"
#import "SteamLanguageInternal.h"

@implementation _SKClientPacketMsg
{
    EMsg _messageType;
    NSData * _data;
    uint64_t _targetJobID;
    uint64_t _sourceJobID;
}

@synthesize data = _data;
@synthesize messageType = _messageType;
@synthesize targetJobID = _targetJobID;
@synthesize sourceJobID = _sourceJobID;

- (BOOL) isProtobuf { return false; }

- (id) initWithEMsg:(EMsg)msg data:(NSData *)data
{
    self = [super init];
    if (self)
    {
        _messageType = msg;
        _data = data;
        
        _SKExtendedClientMsgHdr * extendedHeader = [[_SKExtendedClientMsgHdr alloc] init];
        CRDataReader * reader = [[CRDataReader alloc] initWithData:data];
        [extendedHeader deserializeWithReader:reader];
        
        _targetJobID = extendedHeader.targetJobID;
        _sourceJobID = extendedHeader.sourceJobID;
    }
    return self;
}

@end
