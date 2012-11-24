//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "SteamLanguage.h"

@class SKSteamFriend;
@class SKSteamFriends;
@class CMsgClientPersonaState_Friend;

extern NSString * const SKSteamChatRoomMembersChangedNotification;

@interface SKSteamChatRoom : NSObject

@property (nonatomic, readonly) uint64_t steamId;
@property (nonatomic, readonly) NSArray * members;

- (id) initWithSteamID:(uint64_t)steamId;

- (void) handleChatMemberStateChange:(EChatMemberStateChange)change forFriend:(SKSteamFriend *)friend steamFriends:(SKSteamFriends *)steamFriends;
- (void) handlePersonaStateChange:(CMsgClientPersonaState_Friend *)change steamFriends:(SKSteamFriends *)steamFriends;


@end
