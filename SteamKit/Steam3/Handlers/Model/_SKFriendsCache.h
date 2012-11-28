//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class SKSteamFriend;
@class SKSteamClan;
@class SKSteamChatMessageInfo;
@class SKSteamChatRoom;

@interface _SKFriendsCache : NSObject

@property (nonatomic, readonly) SKSteamFriend * localUser;
@property (nonatomic, readonly) NSArray * friends;
@property (nonatomic, readonly) NSArray * clans;
@property (nonatomic, readonly) NSArray * chats;

- (id) init;
- (SKSteamFriend *) getFriendWithSteamID:(uint64_t)steamId;
- (SKSteamClan *) getClanWithSteamID:(uint64_t)steamId;
- (SKSteamChatRoom *) getChatWithSteamID:(uint64_t)steamId;

- (void) clear;
- (void) setLocalSteamId:(uint64_t)steamId;

- (void) removeFriend:(SKSteamFriend *)steamFriend;
- (void) removeClan:(SKSteamFriend *)clan;
- (void) removeChat:(SKSteamChatRoom *)chat;

- (void) addChatMessageInfo:(SKSteamChatMessageInfo *)info;
- (NSArray *) messagesForFriend:(SKSteamFriend *)steamFriend;
- (NSArray *) messagesForClan:(SKSteamClan *)clan;
- (void) clearChatRoom:(uint64_t)chatRoomId;

@end
