//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "NSData+Multi.h"
#import <zipzap/zipzap.h>

@implementation NSData (Multi)

- (NSData *) sk_decompressedPayload
{
    ZZArchive * archive = [[ZZArchive alloc] initWithData:self encoding:NSUTF8StringEncoding];
    ZZArchiveEntry * entry = archive.entries[0];
    return [entry data];
}

@end
