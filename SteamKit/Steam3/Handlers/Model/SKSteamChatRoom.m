//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamChatRoom.h"
#import "Steammessages_clientserver.pb.h"
#import "SKSteamFriends.h"

NSString * const SKSteamChatRoomMembersChangedNotification = @"SKSteamChatRoomMembersChangedNotification";

@implementation SKSteamChatRoom
{
	NSMutableArray * _members;
}

- (id) initWithSteamID:(uint64_t)steamId
{
	self = [super init];
	if (self)
	{
		_steamId = steamId;
		_members = [@[] mutableCopy];
	}
	return self;
}

- (NSArray *) members
{
	return [_members copy];
}

- (void) handleChatMemberStateChange:(EChatMemberStateChange)change forFriend:(SKSteamFriend *)friend steamFriends:(SKSteamFriends *)steamFriends
{
	switch (change)
	{
		case EChatMemberStateChangeDisconnected:
		case EChatMemberStateChangeKicked:
		case EChatMemberStateChangeLeft:
		case EChatMemberStateChangeBanned:
			if ([_members containsObject:friend])
			{
				[_members removeObject:friend];
			}
			break;
			
		case EChatMemberStateChangeEntered:
			if (![_members containsObject:friend])
			{
				[_members addObject:friend];
			}
			break;
			
		default: break;
	}
}

- (void) handlePersonaStateChange:(CMsgClientPersonaState_Friend *)change steamFriends:(SKSteamFriends *)steamFriends
{
	if (change.hasSteamidSource && change.steamidSource == _steamId)
	{
		SKSteamFriend * friend = [steamFriends friendWithSteamID:change.friendid];
		if (![_members containsObject:friend])
		{
			[_members addObject:friend];
		}
	}
}

@end
