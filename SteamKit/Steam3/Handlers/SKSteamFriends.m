//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamFriends.h"
#import "_SKFriendsCache.h"
#import "_SKClientMsg.h"
#import "_SKClientMsgProtobuf.h"
#import "Steammessages_clientserver.pb.h"
#import "SteamLanguageInternal.h"
#import "SKSteamClient.h"
#import "SKSteamFriend.h"
#import "SKSteamClan.h"
#import "_SKPacketMsg.h"
#import "SKSteamID.h"
#import "SKSteamChatMessageInfo.h"

EClientPersonaStateFlag SKSteamFriendsDefaultFriendInfoRequest =
	EClientPersonaStateFlagPlayerName	|
	EClientPersonaStateFlagPresence		|
	EClientPersonaStateFlagSourceID		|
	EClientPersonaStateFlagGameExtraInfo;

@implementation SKSteamFriends
{
	_SKFriendsCache * _cache;
}

- (id) init
{
	self = [super init];
	if (self)
	{
		_cache = [[_SKFriendsCache alloc] init];
	}
	return self;
}

- (void) handleMessage:(_SKPacketMsg *)packetMessage
{
	switch (packetMessage.messageType)
	{
		case EMsgClientPersonaState:
			[self handleClientPersonaState:packetMessage];
			break;
			
		case EMsgClientFriendsList:
			[self handleClientFriendsList:packetMessage];
			break;
			
		case EMsgClientFriendMsgIncoming:
			[self handleClientFriendMsgIncoming:packetMessage];
			break;
			
		case EMsgClientAccountInfo:
			[self handleClientAccountInfo:packetMessage];
			break;
			
		case EMsgClientChatEnter:
			[self handleClientChatEnter:packetMessage];
			break;
			
		case EMsgClientChatMsg:
			[self handleClientChatMsg:packetMessage];
			break;
			
		case EMsgClientChatMemberInfo:
			[self handleClientChatMemberInfo:packetMessage];
			break;
			
		case EMsgClientChatActionResult:
			[self handleClientChatActionResult:packetMessage];
			break;
			
		case EMsgClientChatInvite:
			[self handleClientChatInvite:packetMessage];
			break;
	}
}

#pragma mark -

- (NSString *)personaName
{
	return _cache.localUser.personaName;
}

- (void) setPersonaName:(NSString *)personaName
{
	// Cache right away, so taht early class to SetPersonaState don't reset the set name.
	_cache.localUser.personaName = personaName;
	
	_SKClientMsgProtobuf * clientChangeStatusMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientChangeStatus class] messageType:EMsgClientChangeStatus];
	
	CMsgClientChangeStatus_Builder * builder = [[CMsgClientChangeStatus_Builder alloc] init];
	[builder setPersonaState:_cache.localUser.personaState];
	[builder setPlayerName:personaName];
	
	clientChangeStatusMessage.body = [builder build];
	[self.steamClient sendMessage:clientChangeStatusMessage];
}

- (EPersonaState)personaState
{
	return _cache.localUser.personaState;
}

- (void) setPersonaState:(EPersonaState)personaState
{	
	_SKClientMsgProtobuf * clientChangeStatusMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientChangeStatus class] messageType:EMsgClientChangeStatus];
	
	CMsgClientChangeStatus_Builder * builder = [[CMsgClientChangeStatus_Builder alloc] init];
	[builder setPersonaState:personaState];
	[builder setPlayerName:_cache.localUser.personaName];
	
	clientChangeStatusMessage.body = [builder build];
	[self.steamClient sendMessage:clientChangeStatusMessage];
}

- (NSArray *) friends
{
	return _cache.friends;
}

- (NSArray *) clans
{
	return _cache.clans;
}

- (void) sendChatMessageToFriend:(SKSteamFriend *)steamFriend type:(EChatEntryType)type text:(NSString *)message
{
	_SKClientMsgProtobuf * clientFriendMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientFriendMsg class] messageType:EMsgClientFriendMsg];
	
	CMsgClientFriendMsg_Builder * builder = [[CMsgClientFriendMsg_Builder alloc] init];
	[builder setSteamid:steamFriend.steamId];
	[builder setChatEntryType:type];
	[builder setMessage:[message dataUsingEncoding:NSUTF8StringEncoding]];
	
	clientFriendMessage.body = [builder build];
	[self.steamClient sendMessage:clientFriendMessage];
}

- (void) removeFriend:(SKSteamFriend *)steamFriend
{
	_SKClientMsgProtobuf * removeFriend = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientRemoveFriend class] messageType:EMsgClientRemoveFriend];
	
	CMsgClientRemoveFriend_Builder * builder = [[CMsgClientRemoveFriend_Builder alloc] init];
	[builder setFriendid:steamFriend.steamId];
	
	removeFriend.body = [builder build];
	[self.steamClient sendMessage:removeFriend];
}

- (void) requestFriendInfoForFriends:(NSArray *)friends requestedInfo:(EClientPersonaStateFlag)requestedInfo
{
	_SKClientMsgProtobuf * request = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientRequestFriendData class] messageType:EMsgClientRequestFriendData];
	
	CMsgClientRequestFriendData_Builder * builder = [[CMsgClientRequestFriendData_Builder alloc] init];
	[builder setFriendsArray:[friends valueForKey:@"steamId"]];
	[builder setPersonaStateRequested:requestedInfo];
	
	request.body = [builder build];
	[self.steamClient sendMessage:request];
}

- (SKSteamFriend *) friendWithSteamID:(uint64_t)steamId
{
	if (steamId == _cache.localUser.steamId)
	{
		return _cache.localUser;
	}
	
	for (SKSteamFriend * friend in self.friends)
	{
		if (friend.steamId == steamId)
		{
			return friend;
		}
	}
	return nil;
}

- (SKSteamClan *) clanWithSteamID:(uint64_t)steamId
{
	for (SKSteamClan * clan in self.clans)
	{
		if (clan.steamId == steamId)
		{
			return clan;
		}
	}
	return nil;
}

- (NSArray *) chatMessageHistoryForFriendWithSteamID:(uint64_t)steamId
{
	return [_cache messagesForFriend:[self friendWithSteamID:steamId]];
}

#pragma mark -
#pragma mark Handlers

- (void) handleClientPersonaState:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * message = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientPersonaState class] packetMessage:packetMessage];
	CMsgClientPersonaState * perState = message.body;
	
	EClientPersonaStateFlag flags = perState.statusFlags;
	
	for(CMsgClientPersonaState_Friend * friend in perState.friends)
	{
		uint64_t friendId = friend.friendid;
//		uint64_t sourceId = friend.steamidSource;
		SKSteamID * friendSteamId = [SKSteamID steamIDWithUnsignedLongLong:friendId];
		
		if (friendSteamId.isIndividualAccount)
		{
			SKSteamFriend * localFriend = [_cache getFriendWithSteamID:friendId];
			
			if ((flags & EClientPersonaStateFlagPlayerName) == EClientPersonaStateFlagPlayerName)
			{
				localFriend.personaName = friend.playerName;
			}
			
			if ((flags & EClientPersonaStateFlagPresence) == EClientPersonaStateFlagPresence)
			{
				localFriend.avatarHash = [friend.avatarHash cr_hexadecimalStringValue];
				localFriend.personaState = friend.personaState;
			}
			
			if ((flags & EClientPersonaStateFlagGameExtraInfo) == EClientPersonaStateFlagGameExtraInfo)
			{
				localFriend.gameName = friend.gameName;
				localFriend.gameId = friend.gameid;
				localFriend.gameAppId = friend.gamePlayedAppId;
			}
		}
		else if (friendSteamId.isClanAccount)
		{
			SKSteamClan * clan = [_cache getClanWithSteamID:friendId];
			
			if ((flags & EClientPersonaStateFlagPlayerName) == EClientPersonaStateFlagPlayerName)
			{
				clan.name = friend.playerName;
			}
		}
	}
}

- (void) handleClientFriendsList:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * message = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientFriendsList class] packetMessage:packetMessage];
	CMsgClientFriendsList * list = message.body;
	
	[_cache setLocalSteamId:self.steamClient.steamID];
	
	if (!list.bincremental)
	{
		[_cache clear];
	}
	
	_SKClientMsgProtobuf * reqInfoMsg = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientRequestFriendData class] messageType:EMsgClientRequestFriendData];
	CMsgClientRequestFriendData_Builder * reqInfoBuilder = [[CMsgClientRequestFriendData_Builder alloc] init];
	[reqInfoBuilder setPersonaStateRequested:SKSteamFriendsDefaultFriendInfoRequest];
	
	NSMutableArray * friendsToRemove = [@[] mutableCopy];
	NSMutableArray * clansToRemove = [@[] mutableCopy];
	
	for(CMsgClientFriendsList_Friend * friendObj in list.friends)
	{
		uint64_t friendId = friendObj.ulfriendid;
		SKSteamID * friendSteamId = [SKSteamID steamIDWithUnsignedLongLong:friendId];
		
		if (friendSteamId.isIndividualAccount)
		{
			SKSteamFriend * localFriend = [_cache getFriendWithSteamID:friendId];
			localFriend.relationship = friendObj.efriendrelationship;
			if ([_cache.friends containsObject:localFriend])
			{
				if (localFriend.relationship == EFriendRelationshipNone)
				{
					[friendsToRemove addObject:localFriend];
				}
			}
		}
		else if (friendSteamId.isClanAccount)
		{
			SKSteamClan * clan = [_cache getClanWithSteamID:friendId];
			clan.relationship = friendObj.efriendrelationship;
			
			if ([_cache.clans containsObject:clan])
			{
				if (clan.relationship == EClanRelationshipNone || clan.relationship == EClanRelationshipKicked)
				{
					[clansToRemove addObject:clan];
				}
			}
		}
	
		if (!list.bincremental)
		{
			[reqInfoBuilder addFriends:friendId];
		}
	}

	[friendsToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[_cache removeFriend:obj];
	}];

	[clansToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[_cache removeClan:obj];
	}];

	if ([[reqInfoBuilder friends] count] > 0)
	{
		reqInfoMsg.body = [reqInfoBuilder build];
		[self.steamClient sendMessage:reqInfoMsg];
	}

}

- (void) handleClientFriendMsgIncoming:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * msg = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientFriendMsgIncoming class] packetMessage:packetMessage];
	CMsgClientFriendMsgIncoming * chatMsg = msg.body;
	
	SKSteamChatMessageInfo * info = [[SKSteamChatMessageInfo alloc] initWithMessage:chatMsg steamFriends:self];
	[_cache addChatMessageInfo:info];
	[self.steamClient postNotification:SKSteamChatMessageInfoNotification withInfo:info];
}

- (void) handleClientAccountInfo:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * accountInfoMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientAccountInfo class] packetMessage:packetMessage];
	CMsgClientAccountInfo * accountInfo = accountInfoMessage.body;
	
	_cache.localUser.personaName = accountInfo.personaName;
}

- (void) handleClientChatEnter:(_SKPacketMsg *)packetMessage
{
}

- (void) handleClientChatMsg:(_SKPacketMsg *)packetMessage
{
	_SKClientMsg * chatMessage = [[_SKClientMsg alloc] initWithBodyClass:[_SKMsgClientChatMsg class] packetMessage:packetMessage];
	_SKMsgClientChatMsg * msg = chatMessage.body;
	
	SKSteamChatMessageInfo * info = [[SKSteamChatMessageInfo alloc] initWithClanMessage:msg textData:chatMessage.payload steamFriends:self];
	[self.steamClient postNotification:SKSteamChatMessageInfoNotification withInfo:info];
}

- (void) handleClientChatMemberInfo:(_SKPacketMsg *)packetMessage
{
}

- (void) handleClientChatActionResult:(_SKPacketMsg *)packetMessage
{
}

- (void) handleClientChatInvite:(_SKPacketMsg *)packetMessage
{
}

@end
