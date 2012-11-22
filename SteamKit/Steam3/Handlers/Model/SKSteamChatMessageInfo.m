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

- (id) initWithMessage:(CMsgClientFriendMsgIncoming *)message steamFriends:(SKSteamFriends *)friends
{
	self = [super init];
	if (self)
	{
		_steamFriendFrom = [friends friendWithSteamID:message.steamidFrom];
		_chatEntryType = message.chatEntryType;
		_message = message.message == nil ? nil : [[NSString alloc] initWithData:message.message encoding:NSUTF8StringEncoding];
		_chatRoomClan = nil;
	}
	return self;
}

- (id) initWithClanMessage:(_SKMsgClientChatMsg *)message textData:(NSData *)textData steamFriends:(SKSteamFriends *)friends
{
	self = [super init];
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
	}
	return self;
}

@end
