//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKMsgBase.h"

@class _SKPacketMsg;
@class _SKExtendedClientMsgHdr;

@interface _SKClientMsg : _SKMsgBase

@property (nonatomic, strong, readwrite) id body;
@property (nonatomic, strong, readonly) _SKExtendedClientMsgHdr * extendedHeader;

- (id) initWithBodyClass:(Class)bodyClass messageType:(EMsg)msg;
- (id) initWithBodyClass:(Class)bodyClass messageType:(EMsg)msg sourceJobMessage:(_SKMsgBase *)sourceJobMessage;
- (id) initWithBodyClass:(Class)bodyClass packetMessage:(_SKPacketMsg *)packetMsg;

@end
