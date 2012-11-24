//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamPersonaStateInfo.h"
#import "SKSteamFriends.h"
#import "Steammessages_clientserver.pb.h"
#import "SKSteamID.h"

NSString * const SKSteamPersonaStateInfoNotification = @"SKSteamPersonaStateInfoNotification";

@implementation SKSteamPersonaStateInfo

- (id) initWithMessage:(CMsgClientPersonaState_Friend *)statefriend steamFriends:(SKSteamFriends *)friends
{
	self = [super init];
	if (self)
	{
		SKSteamID * steamId = [SKSteamID steamIDWithUnsignedLongLong:statefriend.friendid];
		if (steamId.isIndividualAccount)
		{
			_steamFriend = [friends friendWithSteamID:steamId.unsignedLongLongValue];
		} else if (steamId.isClanAccount)
		{
			_clan = [friends clanWithSteamID:steamId.unsignedLongLongValue];
		}
	}
	return self;
}

@end
