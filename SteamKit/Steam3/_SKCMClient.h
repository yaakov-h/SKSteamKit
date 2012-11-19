//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "_SKConnectionDelegate.h"
#import "_SKCMClientDelegate.h"

@class _SKMsgBase;

@interface _SKCMClient : NSObject <_SKConnectionDelegate>

@property (nonatomic, weak) id <_SKCMClientDelegate> delegate;
@property (nonatomic, readonly) uint64_t steamID;

- (BOOL) connectToServer:(NSNumber *)server error:(NSError *__autoreleasing *)error;
- (void) disconnect;

+ (NSArray *) serverList;
- (uint32_t) localIPAddress;

- (void) sendMessage:(_SKMsgBase *)message;

@end
