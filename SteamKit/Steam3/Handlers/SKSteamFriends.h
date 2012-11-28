//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKClientMsgHandler.h"
#import "SteamLanguage.h"

@class SKSteamFriend;
@class SKSteamClan;
@class SKSteamChatRoom;

extern EClientPersonaStateFlag SKSteamFriendsDefaultFriendInfoRequest;

@interface SKSteamFriends : SKClientMsgHandler

@property (nonatomic) NSString * personaName;
@property (nonatomic) EPersonaState personaState;
@property (nonatomic, readonly) NSArray * friends;
@property (nonatomic, readonly) NSArray * clans;
@property (nonatomic, readonly) NSArray * chats;

- (id) init;

- (void) sendChatMessageToFriend:(SKSteamFriend *)steamFriend type:(EChatEntryType)type text:(NSString *)message;
- (void) sendChatMessageToChatRoom:(SKSteamChatRoom *)chatRoom type:(EChatEntryType)type text:(NSString *)message;
- (void) removeFriend:(SKSteamFriend *)steamFriend;
- (void) requestFriendInfoForFriends:(NSArray *)friends requestedInfo:(EClientPersonaStateFlag)requestedInfo;
- (void) requestFriendInfoForClans:(NSArray *)clans requestedInfo:(EClientPersonaStateFlag)requestedInfo;

- (SKSteamFriend *) friendWithSteamID:(uint64_t)steamId;
- (SKSteamClan *) clanWithSteamID:(uint64_t)steamId;
- (SKSteamChatRoom *) chatWithSteamID:(uint64_t)steamId;

- (void) enterChatRoomForClanID:(uint64_t)clanId;
- (void) leaveChatRoomWithID:(uint64_t)chatRoomId;

- (NSArray *) chatMessageHistoryForFriendWithSteamID:(uint64_t)steamId;
- (NSArray *) chatMessageHistoryForClanWithSteamID:(uint64_t)steamId;

@end
