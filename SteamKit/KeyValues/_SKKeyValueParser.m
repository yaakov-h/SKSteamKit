//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKKeyValueParser.h"
#import <CRBoilerplate/CRBoilerplate.h>
#import "SKCRDataReaderExtensions.h"

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

#pragma mark -
#pragma mark Binary

+ (NSDictionary *) readBinaryKeyValues:(CRDataReader *)reader
{
	NSMutableDictionary * dict = [@{} mutableCopy];
	
	[self readBinaryKeyValues:reader intoDictionary:dict];
	
	return [dict copy];
}

+ (void) readBinaryKeyValues:(CRDataReader *)reader intoDictionary:(NSMutableDictionary *)dict
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
				[self readBinaryKeyValues:reader intoDictionary:innerChildren];
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

#pragma mark -
#pragma mark Text

+ (NSDictionary *) readTextKeyValues:(CRDataReader *)reader
{
	NSMutableDictionary * dict = [@{} mutableCopy];
	
	[self readTextKeyValues:reader intoDictionary:dict];
	
	return [dict copy];
}

+ (void) readTextKeyValues:(CRDataReader *)reader intoDictionary:(NSMutableDictionary *)dict
{
	BOOL wasQuoted;
	BOOL wasConditional;
	
	NSMutableDictionary * currentKey = dict;
	
	do {
		BOOL accepted = YES;
		
		NSString * keyName = [reader kv_readTokenQuoted:&wasQuoted conditional:&wasConditional];
		if (keyName == nil || keyName.length == 0)
		{
			break;
		}
		
		NSString * token = [reader kv_readTokenQuoted:&wasQuoted conditional:&wasConditional];
		if (wasConditional)
		{
			accepted = [token isEqualToString:@"[$WIN32]"];
			token = [reader kv_readTokenQuoted:&wasQuoted conditional:&wasConditional];
		}
		
		if ([token hasPrefix:@"{"] && !wasQuoted)
		{
			NSMutableDictionary * child = [@{} mutableCopy];
			[self readTextKeyValuesRecursiveLoad:reader intoDictionary:child];
			dict[keyName] = [child copy];
		} else {
			[NSException raise:@"Invalid Format Exception" format:@"Missing { in KeyValues"];
		}
	} while (![reader kv_isAtEndOfData]);
}

+ (void) readTextKeyValuesRecursiveLoad:(CRDataReader *)reader intoDictionary:(NSMutableDictionary *)dict
{
	BOOL wasQuoted;
	BOOL wasConditional;
	
	while (true)
	{
		BOOL accepted = YES;
		
		NSString * name = [reader kv_readTokenQuoted:&wasQuoted conditional:&wasConditional];
		
		if (name == nil || name.length == 0)
		{
			[NSException raise:@"Invalid KeyValues" format:@"got EOF or empty key name"];
		}
		
		if ([name hasPrefix:@"}"] && !wasQuoted)
		{
			break;
		}
		
		NSMutableDictionary * children = [@{} mutableCopy];
		
		NSString * value = [reader kv_readTokenQuoted:&wasQuoted conditional:&wasConditional];
		if (wasConditional && value != nil)
		{
			accepted = [value isEqualToString:@"[$WIN32]"];
			value = [reader kv_readTokenQuoted:&wasQuoted conditional:&wasConditional];
		}
		
		if (value == nil)
		{
			[NSException raise:@"Invalid KeyValues" format:@"got nil key"];
		}
		
		if ([value hasPrefix:@"}"] && !wasQuoted)
		{
			[NSException raise:@"Invalid KeyValues" format:@"got } in key"];
		}
		
		if ([value hasPrefix:@"{"] && !wasQuoted)
		{
			[self readTextKeyValuesRecursiveLoad:reader intoDictionary:children];
			dict[name] = children;
		} else {
			if (wasConditional)
			{
				[NSException raise:@"Invlaid KeyValues" format:@"got conditional between key and value"];
			}
			
			dict[name] = value;
		}
	}
}

@end
