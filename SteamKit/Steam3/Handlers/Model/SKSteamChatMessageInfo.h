//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "SteamLanguage.h"

extern NSString * const SKSteamChatMessageInfoNotification;

@class SKSteamFriend;
@class SKSteamClan;
@class SKSteamFriends;
@class CMsgClientFriendMsgIncoming;
@class _SKMsgClientChatMsg;

@interface SKSteamChatMessageInfo : NSObject

@property (nonatomic, readonly) SKSteamFriend * steamFriendFrom;
@property (nonatomic, readonly) SKSteamClan * chatRoomClan;
@property (nonatomic, readonly) EChatEntryType chatEntryType;
@property (nonatomic, readonly) NSString * message;
@property (nonatomic, readonly) NSDate * timestamp;

- (id) initWithMessage:(CMsgClientFriendMsgIncoming *)message steamFriends:(SKSteamFriends *)friends;
- (id) initWithClanMessage:(_SKMsgClientChatMsg *)message textData:(NSData *)textData steamFriends:(SKSteamFriends *)friends;

@end
