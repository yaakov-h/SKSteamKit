//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKCRDataReaderExtensions.h"
#import "_SKKeyValueParser.h"

@implementation CRDataReader (SKCRDataReaderExtensions)

- (NSDictionary *) sk_readBinaryKeyValues
{
	return [_SKKeyValueParser readBinaryKeyValues:self];
}

- (NSDictionary *) sk_readTextKeyValues
{
	return [_SKKeyValueParser readTextKeyValues:self];
}

- (uint8_t) kv_peek
{
	uint8_t retVal;
	[self.data getBytes:&retVal range:NSMakeRange(self.position, sizeof(uint8_t))];
	return retVal;
}

- (BOOL) kv_isAtEndOfData
{
	return self.data.length <= self.position;
}

- (void) kv_eatWhitespace
{
	while (![self kv_isAtEndOfData])
	{
		uint8_t peek = [self kv_peek];
		if (![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:peek])
		{
			break;
		}
		[self readUInt8];
	}
}

- (BOOL) kv_eatCPPComment
{
	if (![self kv_isAtEndOfData])
	{
		uint8_t next = [self kv_peek];
		if (next == '/')
		{
			[self readUInt8];
			uint8_t nextAfter = [self kv_peek];
			if (nextAfter == '/')
			{
				[self kv_readLine];
				return YES;
			}
			else
			{
				[NSException raise:@"Invalid KeyValues" format:@"Invalid KV data - only one / found for a comment"];
			}
		}
	}
	
	return NO;
}

- (NSString *) kv_readTokenQuoted:(BOOL *)wasQuoted conditional:(BOOL *)wasConditional
{
	NSDictionary * escapedMapping =
  @{
	@('n') : @('\n'),
 @('r') : @('\r'),
 @('t') : @('\t')
 };
	
	*wasQuoted = NO;
	*wasConditional = NO;
	
	while (true)
	{
		[self kv_eatWhitespace];
		
		if ([self kv_isAtEndOfData])
		{
			return nil;
		}
		
		if (![self kv_eatCPPComment])
		{
			break;
		}
	}
	
	if ([self kv_isAtEndOfData])
	{
		return nil;
	}
	
	uint8_t next = [self kv_peek];
	if (next == '"')
	{
		*wasQuoted = YES;
		[self readUInt8];
		
		NSMutableString * mutString = [[NSMutableString alloc] init];
		
		while (![self kv_isAtEndOfData])
		{
			if ([self kv_peek] == '\\')
			{
				[self readUInt8];
				uint8_t escapedChar = [self readUInt8];
				uint8_t replacedChar = [escapedMapping[@(escapedChar)] unsignedCharValue];
				if (replacedChar > 0)
				{
					[mutString appendFormat:@"%c", replacedChar];
				}
				else
				{
					[mutString appendFormat:@"%c", escapedChar];
				}
				
				continue;
			}
			
			if ([self kv_peek] == '"')
			{
				break;
			}
			
			[mutString appendFormat:@"%c", [self readUInt8]];
		}
		[self readUInt8];
		
		return [mutString copy];
	}
		
	if (next == '{' || next == '}')
	{
		[self readUInt8];
		return [NSString stringWithFormat:@"%c", next];
	}
	
	BOOL conditionalStart = NO;
	int count = 0;
	NSMutableString * ret = [[NSMutableString alloc] init];
	while (![self kv_isAtEndOfData])
	{
		next = [self kv_peek];
		if (next == '"' || next == '{' || next == '}')
		{
			break;
		}
		
		if (next == '[')
		{
			conditionalStart = YES;
		}
		
		if (next == ']' && conditionalStart)
		{
			*wasConditional = YES;
		}
		
		if ([[NSCharacterSet whitespaceCharacterSet] characterIsMember:next])
		{
			break;
		}
		
		if (count < 1023)
		{
			[ret appendFormat:@"%c", next];
		} else {
			[NSException raise:@"ReadToken overflow" format:nil];
		}
		
		[self readUInt8];
	}
	
	return [ret copy];
}

- (void) kv_readLine
{
	while ([self kv_peek] != '\n')
	{
		[self readUInt8];
	}
}

@end
