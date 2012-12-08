//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@interface _SKGCPacketMsg : NSObject

@property (nonatomic, readonly) BOOL isProtobuf;
@property (nonatomic, readonly) uint32_t messageType;
@property (nonatomic, readonly) uint64_t targetJobID;
@property (nonatomic, readonly) uint64_t sourceJobID;
@property (nonatomic, readonly) NSData * data;

- (id) initWithEGCMsg:(uint32_t)msg data:(NSData *)data;

@end
