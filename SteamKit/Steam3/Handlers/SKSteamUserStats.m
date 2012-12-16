//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamUserStats.h"
#import "SteamLanguageInternal.h"
#import "_SKClientMsgProtobuf.h"
#import "SKSteamClient.h"
#import "_SKPacketMsg.h"
#import "_SKClientMsg.h"

@implementation SKSteamUserStats

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
		case EMsgClientGetNumberOfCurrentPlayersResponse:
			[self handleClientGetNumberOfCurrentPlayersResponse:packetMessage];
			break;
			
		default: break;
	}
}

- (CRPromise *) getNumberOfCurrentPlayersForGame:(uint64_t)gameId
{
	_SKClientMsg * message = [[_SKClientMsg alloc] initWithBodyClass:[_SKMsgClientGetNumberOfCurrentPlayers class] messageType:EMsgClientGetNumberOfCurrentPlayers];
	[message.body setGameID:gameId];
	
	return [self.steamClient sendJobMessage:message];
}

#pragma mark -
#pragma mark Handlers

- (void) handleClientGetNumberOfCurrentPlayersResponse:(_SKPacketMsg *)packetMessage
{
	_SKClientMsg * message = [[_SKClientMsg alloc] initWithBodyClass:[_SKMsgClientGetNumberOfCurrentPlayersResponse class] packetMessage:packetMessage];
	_SKMsgClientGetNumberOfCurrentPlayersResponse * response = message.body;
	
	NSNumber * numPlayers = @(response.numPlayers);
	
	[self.steamClient resolveJobMessageWithJobId:packetMessage.targetJobID result:numPlayers];
}

@end
