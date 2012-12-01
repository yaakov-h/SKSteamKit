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

extern NSString * const SKChatRoomChatterActedOnKey;
extern NSString * const SKChatRoomChaterActedByKey;
extern NSString * const SKChatRoomChatterStateChangeKey;
extern NSString * const SKChatRoomKey;

typedef NS_OPTIONS(uint32_t, SKSteamChatRoomPermission)
{
	SKSteamChatRoomPermissionOwner = 1,
	SKSteamChatRoomPermissionOfficer = 2,
	SKSteamChatRoomPermissionNormalUser = 4, // "Normal User" according to dinosaur. Guest?
	SKSteamChatRoomPermissionModerator = 8,
	// There's more but I don't know what they are
};

@interface SKSteamChatRoom : NSObject

@property (nonatomic, readonly) uint64_t steamId;
@property (nonatomic, readonly) NSArray * members;
@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSUInteger maxMembers;

- (id) initWithSteamID:(uint64_t)steamId;
- (SKSteamChatRoomPermission) permissionsForMemberSteamID:(uint64_t)steamId;

//
// PRIVATE METHODS - SKSteamKit INTERNAL ONLY
//
- (void) setChatRoomName:(NSString *)name withMessageObjects:(NSArray *)messageObjects maxMembers:(NSUInteger)maxMembers;
- (void) handleMessageKeyValuesObject:(NSDictionary *)kv;
- (void) handleChatMemberStateChange:(EChatMemberStateChange)change forFriend:(SKSteamFriend *)friend steamFriends:(SKSteamFriends *)steamFriends;
- (void) handlePersonaStateChange:(CMsgClientPersonaState_Friend *)change steamFriends:(SKSteamFriends *)steamFriends;

@end
