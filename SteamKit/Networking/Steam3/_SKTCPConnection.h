//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKConnection.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

@interface _SKTCPConnection : _SKConnection <GCDAsyncSocketDelegate>

- (id) init;
- (BOOL) connectToAddress:(uint32_t)address port:(uint16_t)port error:(NSError *__autoreleasing*)error;

@end
