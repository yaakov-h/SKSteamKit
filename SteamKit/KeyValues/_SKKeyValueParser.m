//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKKeyValueParser.h"
#import <CRBoilerplate/CRBoilerplate.h>

typedef enum
{
	_SKKeyValueFieldTypeNone = 0,
	_SKKeyValueFieldTypeString = 1,
	_SKKeyValueFieldTypeInt32 = 2,
	_SKKeyValueFieldTypeFloat32 = 3,
	_SKKeyValueFieldTypePointer = 4,
	_SKKeyValueFieldTypeWideString = 5,
	_SKKeyValueFieldTypeColor = 6,
	_SKKeyValueFieldTypeUInt64 = 7,
	_SKKeyValueFieldTypeEnd = 8
} _SKKeyValueFieldType;

@implementation _SKKeyValueParser

+ (NSDictionary *) readKeyValues:(CRDataReader *)reader
{
	NSMutableDictionary * dict = [@{} mutableCopy];
	
	[self readKeyValues:reader intoDictionary:dict];
	
	return [dict copy];
}

+ (void) readKeyValues:(CRDataReader *)reader intoDictionary:(NSMutableDictionary *)dict
{
	while (true)
	{
		_SKKeyValueFieldType type = [reader readUInt8];
		
		if (type == _SKKeyValueFieldTypeEnd)
		{
			break;
		}
		
		NSString * name = [reader readUTF8String];
		NSMutableDictionary * innerChildren = [@{} mutableCopy];
		id value = nil;
		
		switch (type)
		{
			case _SKKeyValueFieldTypeNone:
				[self readKeyValues:reader intoDictionary:innerChildren];
				break;
			
			case _SKKeyValueFieldTypeString:
				value = [reader readUTF8String];
				break;
				
			case _SKKeyValueFieldTypeInt32:
			case _SKKeyValueFieldTypeColor:
			case _SKKeyValueFieldTypePointer:
				value = @([reader readInt32]);
				break;
				
			case _SKKeyValueFieldTypeUInt64:
				value = @([reader readUInt64]);
				break;
				
			case _SKKeyValueFieldTypeFloat32:
			{
				NSData * floatData = [reader readDataOfLength:4];
				float flValue = *(float *)[floatData bytes];
				value = @(flValue);
				break;
			}
				
			// Unsupported
			case _SKKeyValueFieldTypeWideString:
			default:
				[dict removeAllObjects];
				return;
		}
		
		if (value != nil)
		{
			dict[name] = value;
		} else if ([innerChildren count] > 0)
		{
			dict[name] = [innerChildren copy];
		}
	}
}

@end
