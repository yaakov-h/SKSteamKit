//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKMsgBase.h"

@class _SKPacketMsg;

@interface _SKClientMsgProtobuf : _SKMsgBase

@property (nonatomic, strong, readwrite) id body;
@property (nonatomic, strong, readonly) CMsgProtoBufHeader * protoHeader;

- (id) initWithBodyClass:(Class)bodyClass messageType:(EMsg)msg;
- (id) initWithBodyClass:(Class)bodyClass messageType:(EMsg)msg sourceJobMessage:(_SKMsgBase *)sourceJobMessage;
- (id) initWithBodyClass:(Class)bodyClass packetMessage:(_SKPacketMsg *)packetMsg;

@end
