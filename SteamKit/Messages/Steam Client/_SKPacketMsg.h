//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "SteamLanguage.h"

@interface _SKPacketMsg : NSObject

@property (nonatomic, readonly) BOOL isProtobuf;
@property (nonatomic, readonly) EMsg messageType;
@property (nonatomic, readonly) uint64_t targetJobID;
@property (nonatomic, readonly) uint64_t sourceJobID;
@property (nonatomic, readonly) NSData * data;

- (id) initWithEMsg:(EMsg)msg data:(NSData *)data;

@end
