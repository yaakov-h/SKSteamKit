//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKEnterChatRoomInfo.h"
#import "SKSteamFriends.h"
#import "SKSteamFriend.h"
#import "SKSteamChatRoom.h"
#import "SteamLanguageInternal.h"
#import "SKSteamID.h"

NSString * const SKEnterChatRoomInfoNotification = @"SKEnterChatRoomInfoNotification";

@implementation SKEnterChatRoomInfo

- (id) initWithMessage:(_SKMsgClientChatEnter *)message friends:(SKSteamFriends *)friends
{
	self = [super init];
	if (self)
	{
		_chatRoom = [friends chatWithSteamID:message.steamIdChat];
		_steamFriend = [friends friendWithSteamID:message.steamIdFriend];
		_chatRoomType = message.chatRoomType;
		_owner = [SKSteamID steamIDWithUnsignedLongLong:message.steamIdOwner];
		_clan = [friends clanWithSteamID:message.steamIdClan];
		_flags = message.chatFlags;
		_response = message.enterResponse;
	}
	return self;
}

@end
