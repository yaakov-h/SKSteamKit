//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@interface _SKGCMsgBase : NSObject

@property (nonatomic, readonly) BOOL isProtobuf;
@property (nonatomic, readonly) uint32_t messageType;
@property (nonatomic, readwrite) uint64_t targetJobID;
@property (nonatomic, readwrite) uint64_t sourceJobID;

@property (nonatomic, strong) id header;
@property (nonatomic, strong) NSMutableData * payload;

- (id) initWithHeaderClass:(Class)headerClass;

- (NSData *)serialize;
- (void) deserialize:(NSData *)data;

@end
