//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "SteamLanguage.h"

@class SKSteamChatRoom;
@class _SKMsgClientChatEnter;
@class SKSteamFriends;
@class SKSteamFriend;
@class SKSteamClan;
@class SKSteamID;

extern NSString * const SKEnterChatRoomInfoNotification;

@interface SKEnterChatRoomInfo : NSObject

@property (nonatomic, readonly) SKSteamChatRoom * chatRoom;
@property (nonatomic, readonly) SKSteamFriend * steamFriend;
@property (nonatomic, readonly) SKSteamClan * clan;
@property (nonatomic, readonly) SKSteamID * owner;
@property (nonatomic, readonly) EChatRoomType chatRoomType;
@property (nonatomic, readonly) uint8_t flags;
@property (nonatomic, readonly) EChatRoomEnterResponse response;

- (id) initWithMessage:(_SKMsgClientChatEnter *)message friends:(SKSteamFriends *)friends;

@end
