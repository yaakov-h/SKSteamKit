//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamChatMessageInfo.h"
#import "SKSteamFriends.h"
#import "Steammessages_clientserver.pb.h"
#import "SteamLanguageInternal.h"
#import "SKSteamID.h"

NSString * const SKSteamChatMessageInfoNotification = @"SKSteamChatMessageInfoNotification";

@implementation SKSteamChatMessageInfo

- (id) init
{
	self = [super init];
	if (self)
	{
		_timestamp = [NSDate date];
	}
	return self;
}

- (id) initWithMessage:(CMsgClientFriendMsgIncoming *)message steamFriends:(SKSteamFriends *)friends
{
	self = [self init];
	if (self)
	{
		_steamFriendFrom = [friends friendWithSteamID:message.steamidFrom];
		_chatEntryType = message.chatEntryType;
		_message = message.message == nil ? nil : [[NSString alloc] initWithData:message.message encoding:NSUTF8StringEncoding];
		_chatRoomClan = nil;
		_chatRoom = nil;
	}
	return self;
}

- (id) initWithClanMessage:(_SKMsgClientChatMsg *)message textData:(NSData *)textData steamFriends:(SKSteamFriends *)friends
{
	self = [self init];
	if (self)
	{
		_steamFriendFrom = [friends friendWithSteamID:message.steamIdChatter];
		_chatEntryType = message.chatMsgType;
		_message = textData == nil ? nil : [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
		
		SKSteamID * steamID = [SKSteamID steamIDWithUnsignedLongLong:message.steamIdChatRoom];
		if (steamID.instance == SKSteamIDChatInstanceFlagClan)
		{
			steamID = [[SKSteamID alloc] initWithUniverse:steamID.universe accountType:EAccountTypeClan instance:0 accountID:steamID.accountID];
		}
		
		_chatRoomClan = [friends clanWithSteamID:steamID.unsignedLongLongValue];
		_chatRoom = [friends chatWithSteamID:message.steamIdChatRoom];
	}
	return self;
}

- (id) initWithFriend:(SKSteamFriend *)steamFriend type:(EChatEntryType)type message:(NSString *)message
{
	self = [self init];
	if (self)
	{
		_steamFriendFrom = steamFriend;
		_chatEntryType = type;
		_message = message;
		_chatRoom = nil;
		_chatRoomClan = nil;
	}
	return self;
}

- (id) initWithFriend:(SKSteamFriend *)steamFriend clan:(SKSteamClan *)clan chatRoom:(SKSteamChatRoom *)room type:(EChatEntryType)type message:(NSString *)message
{
	self = [self init];
	if (self)
	{
		_steamFriendFrom = steamFriend;
		_chatRoomClan = clan;
		_chatRoom = room;
		_chatEntryType = type;
		_message = message;
	}
	return self;
}

@end
