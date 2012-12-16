//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKClientMsgHandler.h"

@class CRPromise;
@class SKSteamWalletInfo;
@class SKSteamAccountInfo;

extern NSString * const SKLogonDetailUsername;
extern NSString * const SKLogonDetailPassword;
extern NSString * const SKLogonDetailSteamGuardCode;
extern NSString * const SKLogonDetailRememberMe;

@interface SKSteamUser : SKClientMsgHandler

@property (nonatomic, readonly) uint64_t steamID;
@property (nonatomic, readonly) SKSteamWalletInfo * walletInfo;
@property (nonatomic, readonly) SKSteamAccountInfo * accountInfo;

- (id) init;

- (CRPromise *) logOnWithDetails:(NSDictionary *)logonDetails;
- (BOOL) hasRememberedPassword;
- (CRPromise *) logOnWithStoredDetails;
- (CRPromise *) logOnAnonymously;

@end
