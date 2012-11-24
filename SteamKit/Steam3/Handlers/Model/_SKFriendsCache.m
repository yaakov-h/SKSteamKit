//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKFriendsCache.h"
#import "SKSteamFriend.h"
#import "SKSteamClan.h"
#import "SKSteamChatMessageInfo.h"
#import "SKSteamChatRoom.h"

@interface SKSteamFriend()
- (void) setSteamId:(uint64_t)steamId;
@end

@implementation _SKFriendsCache
{
	NSMutableArray * _friends;
	NSMutableArray * _clans;
	NSMutableArray * _chats;
	SKSteamFriend * _localUser;
	NSMutableDictionary * _messagesCache;
}

- (id) init
{
	self = [super init];
	if (self)
	{
		_localUser = [[SKSteamFriend alloc] init];
		_friends = [@[] mutableCopy];
		_chats = [@[] mutableCopy];
		_clans = [@[] mutableCopy];
		_messagesCache = [@{} mutableCopy];
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

- (NSArray *) chats
{
	return [_chats copy];
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
	[_messagesCache setObject:[@[] mutableCopy] forKey:@(friend.steamId)];
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
	[_clans addObject:clan];
	[_messagesCache setObject:[@[] mutableCopy] forKey:@(clan.steamId)];
	return clan;
}

- (SKSteamChatRoom *) getChatWithSteamID:(uint64_t)steamId
{
	for (SKSteamChatRoom * chat in _chats) {
		if (chat.steamId == steamId)
		{
			return chat;
		}
	}
	
	SKSteamChatRoom * chat = [[SKSteamChatRoom alloc] initWithSteamID:steamId];
	[_chats addObject:chat];
	return chat;
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

- (void) removeChat:(SKSteamChatRoom *)chat
{
	[_chats removeObject:chat];
}

- (NSArray *) messagesForFriend:(SKSteamFriend *)steamFriend
{
	return [_messagesCache objectForKey:@(steamFriend.steamId)];
}

- (NSArray *) messagesForClan:(SKSteamClan *)clan
{
	return [_messagesCache objectForKey:@(clan.steamId)];
}

- (void) addChatMessageInfo:(SKSteamChatMessageInfo *)info
{
	if (info.chatEntryType == EChatEntryTypeChatMsg)
	{
		if (info.chatRoomClan == nil)
		{
			SKSteamFriend * friend = info.steamFriendFrom;
			[[_messagesCache objectForKey:@(friend.steamId)] addObject:info];
		} else {
			SKSteamClan * clan = info.chatRoomClan;
			[[_messagesCache objectForKey:@(clan.steamId)] addObject:info];
		}
	}
}

@end
