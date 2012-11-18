//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKPlainPacketMsg.h"
#import "SteamLanguageInternal.h"

@implementation _SKPlainPacketMsg
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
        
        _SKMsgHdr * hdr = [[_SKMsgHdr alloc] init];
        [hdr deserializeWithReader:[[CRDataReader alloc] initWithData:data]];
        
        _targetJobID = hdr.targetJobID;
        _sourceJobID = hdr.sourceJobID;
    }
    return self;
}

@end
