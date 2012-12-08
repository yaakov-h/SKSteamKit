//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKGCMsgBase.h"

@implementation _SKGCMsgBase

- (id) initWithHeaderClass:(Class)headerClass
{
    self = [super init];
    if (self)
    {
        self.header = [[headerClass alloc] init];
        self.payload = [NSMutableData data];
    }
    return self;
}

- (NSData *)serialize
{
    [NSException raise:@"Invalid operation" format:@"Unimplemented abstract method -[%@ %@] was called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    return nil;
}

- (void) deserialize:(NSData *)data
{
    [NSException raise:@"Invalid operation" format:@"Unimplemented abstract method -[%@ %@] was called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
}

@end
