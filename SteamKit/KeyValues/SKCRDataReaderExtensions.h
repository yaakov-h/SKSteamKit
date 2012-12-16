//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <CRBoilerplate/CRBoilerplate.h>

@interface CRDataReader (SKCRDataReaderExtensions)

- (NSDictionary *) sk_readBinaryKeyValues;
- (NSDictionary *) sk_readTextKeyValues;

- (uint8_t) kv_peek;
- (BOOL) kv_isAtEndOfData;

- (NSString *) kv_readTokenQuoted:(BOOL *)wasQuoted conditional:(BOOL *)wasConditional;
- (void) kv_eatWhitespace;

@end
