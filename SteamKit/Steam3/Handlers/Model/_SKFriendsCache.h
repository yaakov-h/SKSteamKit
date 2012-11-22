//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class SKSteamFriend;
@class SKSteamClan;

@interface _SKFriendsCache : NSObject

@property (nonatomic, readonly) SKSteamFriend * localUser;
@property (nonatomic, readonly) NSArray * friends;
@property (nonatomic, readonly) NSArray * clans;

- (id) init;
- (SKSteamFriend *) getFriendWithSteamID:(uint64_t)steamId;
- (SKSteamClan *) getClanWithSteamID:(uint64_t)steamId;

- (void) clear;
- (void) setLocalSteamId:(uint64_t)steamId;

- (void) removeFriend:(SKSteamFriend *)steamFriend;
- (void) removeClan:(SKSteamFriend *)clan;

@end
