//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKPacketMsg.h"

@implementation _SKPacketMsg

- (id) initWithEMsg:(EMsg)msg data:(NSData *)data
{
    [NSException raise:@"Invalid operation" format:@"Unimplemented abstract method -[%@ %@] was called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    return nil;
}

- (BOOL) isProtobuf
{
    [NSException raise:@"Invalid operation" format:@"Unimplemented abstract method -[%@ %@] was called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    return NO;
}

- (EMsg) messageType
{
    [NSException raise:@"Invalid operation" format:@"Unimplemented abstract method -[%@ %@] was called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    return EMsgInvalid;
}

- (uint64_t) targetJobID
{
    [NSException raise:@"Invalid operation" format:@"Unimplemented abstract method -[%@ %@] was called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    return -1;
}

- (uint64_t) sourceJobID
{
    [NSException raise:@"Invalid operation" format:@"Unimplemented abstract method -[%@ %@] was called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    return -1;
}

- (NSData *) data
{
    [NSException raise:@"Invalid operation" format:@"Unimplemented abstract method -[%@ %@] was called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    return nil;
}

@end