//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKGCMsgBase.h"

@class _SKMsgGCHdr;
@class _SKGCPacketMsg;

@interface _SKClientGCMsg : _SKGCMsgBase

@property (nonatomic, strong, readwrite) id body;
@property (nonatomic, strong, readonly) _SKMsgGCHdr * extendedHeader;

- (id) initWithBodyClass:(Class)bodyClass messageType:(uint32_t)msg;
- (id) initWithBodyClass:(Class)bodyClass messageType:(uint32_t)msg sourceJobMessage:(_SKGCMsgBase *)sourceJobMessage;
- (id) initWithBodyClass:(Class)bodyClass packetMessage:(_SKGCPacketMsg *)packetMsg;

@end
