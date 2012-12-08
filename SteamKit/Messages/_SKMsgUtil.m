//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKMsgUtil.h"

static const uint32_t _SKMsgProtoMask = 0x80000000;
static const uint32_t _SKMsgEMsgMask = ~_SKMsgProtoMask;

@implementation _SKMsgUtil

+ (int32_t) makeMsg:(EMsg)msg isProtobuf:(BOOL)isProtobuf
{
    if (isProtobuf)
    {
        return ( msg | _SKMsgProtoMask );
    }
    
    return msg;
}

+ (EMsg) getMsg:(uint32_t)msg
{
    return (EMsg)( msg & _SKMsgEMsgMask );
}

+ (BOOL) isProtobuf:(uint32_t)msg
{
    return ( msg & _SKMsgProtoMask ) == _SKMsgProtoMask;
}

+ (uint32_t) makeGCMsg:(uint32_t)msg isProtobuf:(BOOL)isProtobuf
{
	if (isProtobuf)
	{
		return msg | _SKMsgProtoMask;
	}
	else
	{
		return msg;
	}
}

+ (uint32_t) getGCMsg:(uint32_t)msg
{
	return msg & _SKMsgEMsgMask;
}

@end
