//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKFriendsCache.h"
#import "SKSteamFriend.h"
#import "SKSteamClan.h"

@interface SKSteamFriend()
- (void) setSteamId:(uint64_t)steamId;
@end

@implementation _SKFriendsCache
{
	NSMutableArray * _friends;
	NSMutableArray * _clans;
	SKSteamFriend * _localUser;
}

- (id) init
{
	self = [super init];
	if (self)
	{
		_localUser = [[SKSteamFriend alloc] init];
		_friends = [@[] mutableCopy];
		_clans = [@[] mutableCopy];
	}
	return self;
}

- (SKSteamFriend *) localUser
{
	return _localUser;
}

- (NSArray *) friends
{
	return [_friends copy];
}

- (NSArray *) clans
{
	return [_clans copy];
}

- (SKSteamFriend *) getFriendWithSteamID:(uint64_t)steamId
{
	for (SKSteamFriend * friend in _friends) {
		if (friend.steamId == steamId)
		{
			return friend;
		}
	}
	
	SKSteamFriend * friend = [[SKSteamFriend alloc] initWithSteamID:steamId];
	[_friends addObject:friend];
	return friend;
}

- (SKSteamClan *) getClanWithSteamID:(uint64_t)steamId
{
	for (SKSteamClan * clan in _clans) {
		if (clan.steamId == steamId)
		{
			return clan;
		}
	}
	
	SKSteamClan * clan = [[SKSteamClan alloc] initWithSteamID:steamId];
	[_friends addObject:clan];
	return clan;
}

- (void) clear
{
	[_friends removeAllObjects];
	[_clans removeAllObjects];
}

- (void) setLocalSteamId:(uint64_t)steamId
{
	self.localUser.steamId = steamId;
}

- (void) removeFriend:(SKSteamFriend *)steamFriend
{
	[_friends removeObject:steamFriend];
}

- (void) removeClan:(SKSteamFriend *)clan
{
	[_clans removeObject:clan];
}

@end
