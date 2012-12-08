//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKClientGCPacketMsg.h"
#import "SteamLanguageInternal.h"

@implementation _SKClientGCPacketMsg
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

- (BOOL) isProtobuf { return false; }

- (id) initWithEGCMsg:(uint32_t)msg data:(NSData *)data
{
    self = [super init];
    if (self)
    {
        _messageType = msg;
        _data = data;
        
        _SKMsgGCHdr * gcHeader = [[_SKMsgGCHdr alloc] init];
        CRDataReader * reader = [[CRDataReader alloc] initWithData:data];
        [gcHeader deserializeWithReader:reader];
        
        _targetJobID = gcHeader.targetJobID;
        _sourceJobID = gcHeader.sourceJobID;
    }
    return self;
}

@end
