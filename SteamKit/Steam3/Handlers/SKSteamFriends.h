//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKClientMsgHandler.h"
#import "SteamLanguage.h"

@class SKSteamFriend;
@class SKSteamClan;

extern EClientPersonaStateFlag SKSteamFriendsDefaultFriendInfoRequest;

@interface SKSteamFriends : SKClientMsgHandler

@property (nonatomic) NSString * personaName;
@property (nonatomic) EPersonaState personaState;
@property (nonatomic, readonly) NSArray * friends;
@property (nonatomic, readonly) NSArray * clans;

- (id) init;

- (void) sendChatMessageToFriend:(SKSteamFriend *)steamFriend type:(EChatEntryType)type text:(NSString *)message;
- (void) removeFriend:(SKSteamFriend *)steamFriend;
- (void) requestFriendInfoForFriends:(NSArray *)friends requestedInfo:(EClientPersonaStateFlag)requestedInfo;

- (SKSteamFriend *) friendWithSteamID:(uint64_t)steamId;
- (SKSteamClan *) clanWithSteamID:(uint64_t)steamId;

@end
