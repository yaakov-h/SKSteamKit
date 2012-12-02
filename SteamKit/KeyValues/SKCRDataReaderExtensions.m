//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKCRDataReaderExtensions.h"
#import "_SKKeyValueParser.h"

@implementation CRDataReader (SKCRDataReaderExtensions)

- (NSDictionary *) sk_readKeyValues
{
	return [_SKKeyValueParser readKeyValues:self];
}

@end
