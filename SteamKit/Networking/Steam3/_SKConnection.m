//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKConnection.h"

@implementation _SKConnection

- (void) sendMessage:(_SKMsgBase *) message
{
    [NSException raise:@"Invalid operation" format:@"Unimplemented abstract method -[%@ %@] was called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
}

- (uint32_t) localIPAddress
{
    [NSException raise:@"Invalid operation" format:@"Unimplemented abstract method -[%@ %@] was called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    return 0;
}

- (BOOL) connectToAddress:(uint32_t)address port:(uint16_t)port error:(NSError *__autoreleasing*)error
{
    [NSException raise:@"Invalid operation" format:@"Unimplemented abstract method -[%@ %@] was called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    return NO;
}

@end
