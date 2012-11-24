//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamApps.h"
#import "_SKPacketMsg.h"
#import "_SKClientMsgProtobuf.h"
#import "Steammessages_clientserver.pb.h"
#import "SKLicenceListInfo.h"
#import "SKSteamClient.h"

@implementation SKSteamApps

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
		case EMsgClientLicenseList:
			[self handleLicenceList:packetMessage];
			break;
			
		case EMsgClientVACBanStatus:
			[self handleClientVACBanStatus:packetMessage];
			break;
			
		case EMsgClientAppInfoChanges:
			[self handleClientAppInfoChanges:packetMessage];
			break;
		
		case EMsgClientAppInfoResponse:
			[self handleClientAppInfoResponse:packetMessage];
			break;
			
		case EMsgClientPackageInfoResponse:
			[self handleClientPackageInfoResponse:packetMessage];
			break;
			
		default: break;
	}
}

#pragma mark -
#pragma mark Handlers

- (void) handleLicenceList:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * message = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientLicenseList class] packetMessage:packetMessage];
	CMsgClientLicenseList * list = message.body;
	
	SKLicenceListInfo * info = [[SKLicenceListInfo alloc] initWithMessage:list];
	[self.steamClient postNotification:SKSteamLicenceListInfoUpdateNotification withInfo:info];
}

- (void) handleClientVACBanStatus:(_SKPacketMsg *)packetMessage
{
	// TODO
}

- (void) handleClientAppInfoChanges:(_SKPacketMsg *)packetMessage
{
}

- (void) handleClientAppInfoResponse:(_SKPacketMsg *)packetMessage
{
	// Requires KeyValue parsing to be useful
}

- (void) handleClientPackageInfoResponse:(_SKPacketMsg *)packetMessage
{
	// Requires KeyValues parsing to be useful
}

@end
