//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamGameCoordinator.h"
#import "SteamLanguageInternal.h"
#import "_SKClientMsgProtobuf.h"
#import "_SKMsgUtil.h"
#import "_SKClientGCMsg.h"
#import "SKSteamClient.h"
#import "_SKPacketMsg.h"
#import "_SKGCPacketMsg.h"
#import "_SKClientGCPacketMsg.h"
#import "_SKProtobufGCPacketMsg.h"

@implementation SKSteamGameCoordinator

- (id) init
{
	self = [super init];
	if (self)
	{
	}
	return self;
}

- (void) handleMessage:(_SKPacketMsg *)packetMessage
{
	switch (packetMessage.messageType)
	{
		case EMsgClientFromGC:
			[self handleClientFromGC:packetMessage];
			break;
			
		default: break;
	}
}

- (void) sendGCMessage:(_SKClientGCMsg *)message forApp:(uint32_t) appID
{
	_SKClientMsgProtobuf * steamMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgGCClient class] messageType:EMsgClientToGC];
	
	CMsgGCClient_Builder * builder = [[CMsgGCClient_Builder alloc] init];
	[builder setMsgtype:[_SKMsgUtil makeGCMsg:message.messageType isProtobuf:message.isProtobuf]];
	[builder setAppid:appID];
	[builder setPayload:[message serialize]];
	
	steamMessage.body = [builder build];
	[self.steamClient sendMessage:steamMessage];
}

- (_SKGCPacketMsg *) parsePacketGCMsgOfType:(uint32_t)eMsg fromData:(NSData *)data
{
	uint32_t realMessageType = [_SKMsgUtil getGCMsg:eMsg];
	
	if ([_SKMsgUtil isProtobuf:eMsg])
	{
		return [[_SKProtobufGCPacketMsg alloc] initWithEGCMsg:realMessageType data:data];
	}
	else
	{
		return [[_SKClientGCPacketMsg alloc] initWithEGCMsg:realMessageType data:data];
	}
}

#pragma mark -
#pragma mark Handlers

- (void) handleClientFromGC:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * steamMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgGCClient class] packetMessage:packetMessage];
	CMsgGCClient * gcMsg = steamMessage.body;
	
	uint32_t eMsg = gcMsg.msgtype;
	uint32_t appID = gcMsg.appid;
	
	NSData * payload = gcMsg.payload;
	
	_SKGCPacketMsg * gcPacketMessage = [self parsePacketGCMsgOfType:eMsg fromData:payload];
	
	NSLog(@"\r\n\r\n>>>> Got GC message %u (protobuf: %@)\r\n\r\n", gcPacketMessage.messageType, gcPacketMessage.isProtobuf ? @"YES" : @"NO");
}

@end
