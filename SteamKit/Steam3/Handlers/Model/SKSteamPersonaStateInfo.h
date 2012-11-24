//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class SKSteamFriend;
@class SKSteamClan;
@class CMsgClientPersonaState_Friend;
@class SKSteamFriends;

extern NSString * const SKSteamPersonaStateInfoNotification;

@interface SKSteamPersonaStateInfo : NSObject

@property (nonatomic, readonly) SKSteamFriend * steamFriend;
@property (nonatomic, readonly) SKSteamClan * clan;

- (id) initWithMessage:(CMsgClientPersonaState_Friend *)statefriend steamFriends:(SKSteamFriends *)friends;

@end
