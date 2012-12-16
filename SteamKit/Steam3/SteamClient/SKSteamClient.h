//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "SteamLanguage.h"

@class SKClientMsgHandler;
@class _SKCMClient;
@class _SKMsgBase;
@class SKSteamUser;
@class SKSteamFriends;
@class SKSteamApps;
@class CRPromise;
@class SKSteamGameCoordinator;

extern NSString * SKSteamClientDisconnectedNotification;

@interface SKSteamClient : NSObject

@property (nonatomic, readonly) uint64_t steamID;

@property (nonatomic, readonly) _SKCMClient * client;
@property (nonatomic, readonly) NSArray * handlers;
@property (nonatomic, readonly) EUniverse connectedUniverse;

@property (nonatomic, readonly) SKSteamUser * steamUser;
@property (nonatomic, readonly) SKSteamFriends * steamFriends;
@property (nonatomic, readonly) SKSteamApps * steamApps;
@property (nonatomic, readonly) SKSteamGameCoordinator * steamGameCoordinator;

- (void) addHandler:(SKClientMsgHandler *)handler;
- (void) removeHandler:(SKClientMsgHandler *)handler;

- (CRPromise *) connect;
- (void) disconnect;

- (void) sendMessage:(_SKMsgBase *)message;
- (void) postNotification:(NSString *)notificationName withInfo:(NSObject *)info;

@end
