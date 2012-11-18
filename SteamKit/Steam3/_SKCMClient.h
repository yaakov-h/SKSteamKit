//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "_SKConnectionDelegate.h"

@class _SKMsgBase;

@interface _SKCMClient : NSObject <_SKConnectionDelegate>

- (BOOL) connectToServer:(NSNumber *)server error:(NSError *__autoreleasing *)error;
+ (NSArray *) serverList;
- (uint32_t) localIPAddress;

- (void) sendMessage:(_SKMsgBase *)message;

@end
