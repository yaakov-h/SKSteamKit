//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class CRDataReader;

@interface _SKKeyValueParser : NSObject

+ (NSDictionary *) readKeyValues:(CRDataReader *)reader;

@end
