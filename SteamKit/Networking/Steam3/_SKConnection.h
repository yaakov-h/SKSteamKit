//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "_SKConnectionDelegate.h"
#import "_SKMsgBase.h"

@class _SKNetFilterEncryption;

@interface _SKConnection : NSObject

@property (nonatomic, strong) _SKNetFilterEncryption * netFilter;
@property (nonatomic, weak) id<_SKConnectionDelegate> delegate;

- (void) sendMessage:(_SKMsgBase *) message;

- (uint32_t) localIPAddress;
- (BOOL) connectToAddress:(uint32_t)address port:(uint16_t)port error:(NSError *__autoreleasing*)error;
- (void) disconnect;

@end
