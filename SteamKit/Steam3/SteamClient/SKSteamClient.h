//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class SKClientMsgHandler;
@class _SKCMClient;
@class _SKMsgBase;
@class SKSteamUser;
@class CRPromise;

@interface SKSteamClient : NSObject

@property (nonatomic, readonly) _SKCMClient * client;
@property (nonatomic, readonly) NSArray * handlers;

@property (nonatomic, readonly) SKSteamUser * steamUser;

- (void) addHandler:(SKClientMsgHandler *)handler;
- (void) removeHandler:(SKClientMsgHandler *)handler;

- (CRPromise *) connect;
- (void) disconnect;

- (void) sendMessage:(_SKMsgBase *)message;

@end
